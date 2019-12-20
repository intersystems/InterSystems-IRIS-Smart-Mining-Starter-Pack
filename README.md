# ASP - Mining Started Pack

This repository holds the initial work we are doing for the mining use cases in Chile including OEE and Machine Learning use cases.

## Build and run it

Run the build scripts (build.sh or build.bat) to build the image on your PC.

Run the run scripts (run.sh or run.bat) to run it. If you call the run script without a parameter, it will start only the OEE container. If you call the run script with the **all** parameter, it will start the composition that would include OEE, Zeppelin and the Spark cluster:

this w
```bash
./run.sh all
```

## Where is the Management Portal and what are my credentials?

Here is the list of end points:
* IRIS OEE - http://localhost:52773/csp/sys/UtilHome.csp
  * The credentials are: SuperUser/sys
* Zeppelin - http://localhost:10000
* Spark:
  * Spark UI: http://localhost:10001 - This is only available after running one spark job
  * Spark Cluster: http://localhost:8080

## Where is the Quick ML instructions?

[Here](QUICKML.md).