@echo off

set DOCKER_REPO=intersystemsdc/irisdemo-demo-oee
set /p VERSION=<VERSION

docker run --rm --init --name oee -p 51773:51773 -p 52773:52773 %DOCKER_REPO%:version-%VERSION%
