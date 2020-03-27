# ASP - Mining Started Pack

This repository holds the initial work we are doing for the mining use cases in Chile including OEE and Machine Learning use cases.

## Build and run it

Because this image is based on a special, unreleased, version of IRIS (that includes QuickML), you must first load this base image from a tar file named **starterpack-base-irisint.tar**. Make sure that this tar file is on the same folder where this README.md file is and run the **loadtar.sh** script.

Once the base image is loaded, run the **build.sh** script to build the final image on your PC.

## Start the Image

To start the image, run the **run.sh** script. If you call the run script without a parameter, it will start only the OEE container. If you call the run script with the **all** parameter, it will start the composition that would include OEE, Zeppelin and the Spark cluster:

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

## Sample BDs
Minecare: devsl.xompass.com:1401 SA/Modular1
Powerview: 200.104.39.222:1433 SA/perrovaca
