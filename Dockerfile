FROM arm32v7/python:3.7-slim-buster

RUN apt-get update && apt-get upgrade
RUN apt-get install python3-pip -y

RUN pip3 install --no-cache-dir ephem configparser Flask paho-mqtt requests pigpio

ADD . /pisomfy
 
RUN sed -i -e 's/pi\ =\ pigpio\.pi()/pi\ =\ pigpio\.pi("localhost")/g' /pisomfy/operateShutters.py \
    && sed -i -e 's/if\ sys\.version_info\[0\]\ <\ 3\:/return\ True\ # no need to start pigpiod inside docker, connecting to host instead!\n\ \ \ \ \ \ \ if\ sys\.version_info\[0\]\ <\ 3\:/g' /pisomfy/operateShutters.py


CMD ["python3", "/pisomfy/operateShutters.py", "-a", "-e", "-c", "/config/operateShutters.conf"]
