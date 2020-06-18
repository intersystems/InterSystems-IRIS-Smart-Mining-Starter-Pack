#!/bin/bash
DOCKER_REPO=intersystemsdc/mining
VERSION=`cat ./VERSION`
docker build -t ${DOCKER_REPO}:oee-version-${VERSION} .
