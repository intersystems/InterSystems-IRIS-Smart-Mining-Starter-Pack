@echo off

set DOCKER_REPO=intersystemsdc/irisdemo-demo-oee
set /p VERSION=<VERSION

docker build -t %DOCKER_REPO%:version-%VERSION% .
