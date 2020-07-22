FROM intersystemsdc/starterpack-base-irisint:version-1.6
#FROM intersystemsdc/irisdemo-base-irisint-community:version-1.6

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=ASP-Mining-project
 
# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR
ADD --chown=irisowner:irisuser ./iris-analytics/*.xml $IRIS_APP_SOURCEDIR

ADD --chown=irisowner:irisuser ./res/* /tmp/
ADD --chown=irisowner:irisuser ./res/utils/* /tmp/utils/

ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Running the installer. This will load the source from our project.
RUN mkdir -p /tmp/iris-analytics
RUN /tmp/utils/irisdemoinstaller.sh 
    #rm -f /tmp/export_to_hisdb.csv
