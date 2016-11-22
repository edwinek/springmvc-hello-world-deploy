FROM edwinek/alpine-jdk8-maven:latest

ADD springmvc-hello-world-src.tar /opt/src
WORKDIR /opt/src
RUN mvn package
