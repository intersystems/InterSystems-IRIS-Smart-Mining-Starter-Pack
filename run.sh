#!/bin/bash

DOCKER_REPO=intersystemsdc/irisdemo-demo-oee
VERSION=`cat ./VERSION`

docker run --rm --init --name oee -p 51773:51773 -p 52773:52773 ${DOCKER_REPO}:version-${VERSION}
