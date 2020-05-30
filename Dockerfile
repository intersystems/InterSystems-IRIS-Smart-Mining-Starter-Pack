#FROM intersystemsdc/irisdemo-base-irisint-community:version-1.6
FROM intersystemsdc/starterpack-base-irisint:version-1.6

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=OEE-iris-project
 
# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR
ADD --chown=irisowner:irisuser ./iris-analytics/*.xml $IRIS_APP_SOURCEDIR

ADD --chown=irisowner:irisuser ./production_data.tar.gz /tmp/

ADD --chown=irisowner:irisuser ./csv /tmp/
ADD --chown=irisowner:irisuser ./mssql-jdbc-7.4.1.jre8.jar /tmp/


# Running the installer. This will load the source from our project.
RUN mkdir -p /tmp/iris-analytics
RUN /usr/irissys/demo/irisdemoinstaller.sh 
    #rm -f /tmp/export_to_hisdb.csv
