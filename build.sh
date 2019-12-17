#!/bin/bash

DOCKER_REPO=intersystemsdc/irisdemo-demo-oee
VERSION=`cat ./VERSION`

docker build -t ${DOCKER_REPO}:version-${VERSION} .
