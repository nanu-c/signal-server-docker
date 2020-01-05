# Open Whisper Systems TextSecure Server

# Build the image with
# docker build --rm -t signal-server .

# Run the container in a directory containing the jar/ and config/ dirs
# and the scripts referenced here
#
# docker run -p 8080:8080 -p 8081:8081 -P -v $(pwd):/home/whisper -it whisper

FROM ubuntu:19.04

MAINTAINER Aaron Kimmig <aaron@kimmigs.de>

RUN DEBIAN_FRONTEND='noninteractive' apt-get update && apt-get install -y redis-server postgresql supervisor openjdk-13-jre-headless

RUN adduser --disabled-password --quiet --gecos Whisper whisper
ENV HOME /home/whisper
WORKDIR /home/whisper

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /home/whisper/jar

ADD Signal-Server/service/target/*.jar /home/whisper/jar/
ADD Signal-Server/websocket-resources/target/*.jar /home/whisper/jar/
ADD Signal-Server/redis-dispatch/target/*.jar /home/whisper/jar/
ADD Signal-Server/gcm-sender-async/target/*.jar /home/whisper/jar/

RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y sudo

RUN /etc/init.d/postgresql start && \
 sudo -u postgres psql --command "CREATE USER whisper WITH SUPERUSER PASSWORD 'whisper';" && \
 sudo -u postgres createdb -O whisper accountdb && \
 sudo -u postgres createdb -O whisper messagedb

ADD scripts/* /home/whisper/

EXPOSE 8080 8081

CMD ./run-server
