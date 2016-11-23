#! /bin/bash

PROJECT_NAME=springmvc-hello-world
PROJECT_URL=http://www.github.com/edwinek/$PROJECT_NAME
SRC_ARCHIVE=$PROJECT_NAME-src.tar
WAR_FILE=$PROJECT_NAME.war

function cleanup_containers_and_files() {
    rm builder/$SRC_ARCHIVE
    rm deployer/$WAR_FILE
	docker rm hw_getter_container
	docker rm hw_builder_container
	docker rm hw_deployer_container
}

cleanup_containers_and_files

docker run --name hw_getter_container -tid edwinek/alpine-git:latest sh
docker exec -ti hw_getter_container git clone $PROJECT_URL /opt/src/$PROJECT_NAME
docker exec -ti hw_getter_container sh -c "cd /opt/src/$PROJECT_NAME && git archive -o /tmp/$SRC_ARCHIVE master"
docker cp hw_getter_container:/tmp/$SRC_ARCHIVE builder/$SRC_ARCHIVE
docker stop hw_getter_container

docker build -t hw_builder_image builder/.
docker run --name hw_builder_container -tid hw_builder_image sh
docker cp hw_builder_container:/opt/src/target/$WAR_FILE deployer/$WAR_FILE
docker stop hw_builder_container

docker build -t hw_deployer_image deployer/.
docker run --name hw_deployer_container -ti -p 8888:8080 hw_deployer_image
docker stop hw_deployer_container

cleanup_containers_and_files