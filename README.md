# ASP - Mining Started Pack

This repository holds the initial work we are doing for the mining use cases in Chile including OEE and base model for mining interoperability.

## Option 1: Build and run development version

### Download Docker base image
[Docker Image] (https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/EfeiI2IE6EBPstctf-VtoWkBi4btpubpF5zUQE0R7EjUQg?e=f6HKvO)

Install with:
```bash
docker load -i starterpack-base-irisint.tar
```
### Clone Repo and run
```bash
git clone git@github.com:intersystems/asp-mining.git
cd asp-mining
./build.sh
./run.sh [-d,all]
```

## Option 2: Download and run a prebuilt docker image
```
[ASP-Mining v0.4.2](https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/ESvpDvFuLEtJtVt8SlI5NKYBbpR0SJjDhgQApKk0bZ7QfA?e=KP5Lgn)
gunzip asp-mining_0.4.2.tar.gz
docker load -i asp-mining_0.4.2.tar
```

## Setting up mining dataset in SQL Server

###  Clone a Linux Local DB
Run a Docker SQL Server 2019, using the provided MiningDBsV2.tar file and follow the instructions inside the README file. [Download Here](https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/EZEqZkotoS1Hgis7J5skeIYBApzKJoxoZVhGnCr5F-J-Gw?e=OX1zvY)

###  Clone an anonymized SQL DB
Run a Docker SQL Server 2019, using the provided MiningDBsV2tiny.tar file and follow the instructions inside the README file. [to be uploaded...](uploading...)

## Testing the Production
The development production is disabled by default to reduce the time spent when relaunching the docker image, and better controlling the excecution of the Business Services in the Package when doing changes in the code.

### 1. Open the Default Production and enable one of the service.
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i1.png)
### 2. Run the production for at least 5 minutes to import a couple days worth of data.
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i2.png)

## Building Cubes
The following Cubes are always updated every 1 minute.
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i3.png)


## Check the FrontEnd app
[Follow the instructions in here](https://github.com/intersystems/asp-mining/tree/master/FrontEnd) 

## Want to Use IAM?
[Follow the instructions in here](https://github.com/intersystems/asp-mining/tree/master/Docs/iam) 

## Where is the Management Portal and what are my credentials?

Here is the list of end points:
* IRIS OEE - http://localhost:52773/csp/sys/UtilHome.csp
  * The credentials are: SuperUser/sys
* Zeppelin - http://localhost:10000
* Spark:
  * Spark UI: http://localhost:10001 - This is only available after running one spark job
  * Spark Cluster: http://localhost:8080

## Where is the Quick ML instructions?

1. Enable the production
[Here](QUICKML.md).
