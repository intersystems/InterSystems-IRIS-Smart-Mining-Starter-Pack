#!/bin/bash

YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

DOCKER_REPO=intersystemsdc/mining
VERSION=`cat ./VERSION`

cleanup()
{
    printf "\n\n${PURPLE}CTRL+C detected. Removing containters...${RESET}\n"
    docker-compose stop
    docker-compose rm -f

    printf "\n\n${PURPLE}Cleaning up complete.${RESET}\n"
    trap - INT
}
trap cleanup INT

if [ "$1" = "all" ];
then
    docker-compose stop
    docker-compose rm -f
    docker-compose up --remove-orphans
else
    docker run --rm --init --name oee -v "$PWD/iris-analytics":/tmp/iris-analytics -p 51773:51773 -p 52773:52773 ${DOCKER_REPO}:oee-version-${VERSION}
fi
# 
