# ASP - Mining Started Pack

This repository holds the initial work we are doing for the mining use cases in Chile including OEE and base model for mining interoperability.

## Build and run development version

```bash
git clone git@github.com:intersystems/asp-mining.git
cd asp-mining
./build.sh
./run.sh [-d,all]
```

## Setting up mining dataset in SQL Server

### Option 1 - Linux Local DB
Run a Docker SQL Server 2019, using the provided MiningDBsV2.tar file and follow the instructions inside the README file. [Download Here](https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/EZEqZkotoS1Hgis7J5skeIYBApzKJoxoZVhGnCr5F-J-Gw?e=OX1zvY)
### Option 2 - Connect to SQL DB
iris:oee@dev.austekchile.cl:1433

## Enabling the development Production
The development production is disabled by default to reduce the time spent when relaunching the docker image, and better controlling the excecution of the Business Services in the Package when doing changes in the code.




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
The following options contain 3 Sample databases:  
**MineCare**: A samll dump of a MineCare DB of a mine  
**PowerView**: A samll dump of a PowerView DB of the same mine than MineCare dump  
**PowerViewCH**: A 1 year dump of a PowerView DB of a different mine  