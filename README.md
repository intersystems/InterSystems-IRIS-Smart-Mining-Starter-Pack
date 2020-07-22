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

### Download Docker base image
[Docker Image] (https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/EfeiI2IE6EBPstctf-VtoWkBi4btpubpF5zUQE0R7EjUQg?e=f6HKvO)

Install with:
```bash
docker load -i starterpack-base-irisint.tar
```

###  Clone a Linux Local DB
Run a Docker SQL Server 2019, using the provided MiningDBsV2.tar file and follow the instructions inside the README file. [Download Here](https://devxompass-my.sharepoint.com/:u:/g/personal/andres_xompass_com/EZEqZkotoS1Hgis7J5skeIYBApzKJoxoZVhGnCr5F-J-Gw?e=OX1zvY)

## Testing the Production
The development production is disabled by default to reduce the time spent when relaunching the docker image, and better controlling the excecution of the Business Services in the Package when doing changes in the code.

### 1. Open the Default Production and enable one of the service.
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i1.png)
### 2. Run the production for 5 minutes to import a couple days worth of data.
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i2.png)
### 3. Go To analytics portal
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i3.png)
### 4. Open a Cube
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i4.png)
### 5. Build the Cube
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i7.png)
### 6. Go To Analyzer to check the results
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i5.png)
### 7. Validate the cube output
![](https://github.com/intersystems/asp-mining/blob/master/res/img/i6.png)



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

## Sample BDs
The following options contain 3 Sample databases:  
**MineCare**: A samll dump of a MineCare DB of a mine  
**PowerView**: A samll dump of a PowerView DB of the same mine than MineCare dump  
**PowerViewCH**: A 1 year dump of a PowerView DB of a different mine  
