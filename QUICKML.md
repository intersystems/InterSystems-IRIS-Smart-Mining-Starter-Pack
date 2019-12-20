# QuickML Demo Kit

This repo contains a few simple datasets to demonstrate QuickML. 

## How to build

The included Dockerfile will pull a QuickML-enabled container image from our internal Docker repository, inject a license and set up a few simple datasets. See [here](https://usconfluence.iscinternal.com/display/RE/Quay+Docker+Repository+Access) if you haven't used docker.iscinternal.com before.

:warning: For minimal security reasons, **an IRIS key is not included in this repo**, and this will be your one manual step in order to be able to build an image. Pick a docker-enabled key from the [SE License key bundle](http://twiki6.iscinternal.com/twiki/bin/view/ISC/LicenseKeys) and save it as ```iris.key``` in the root folder of your local download of this repo (so next to README.md and Dockerfile). Then use the following command to start building

```
docker build --tag quickml-demo .
```

To start your container, use the following command (or your favourite equivalent, as this one will drop your container after stopping)

```
docker run --rm -d -p 9091:51773 -p 9092:52773 --name quickml quickml-demo
```

The IRIS password is initialized as SYS, but you can get in directly through the following command, the SMP or connecting through a SQL client such as [DBeaver](https://dbeaver.io/)

```
docker exec -it quickml iris sql IRIS
```

## How to demo

Using QuickML takes only three simple commands:

```sql
CREATE MODEL Flowers PREDICTING (Species) FROM DataMining.IrisDataset;
TRAIN MODEL Flowers FROM DataMining.IrisDataset;
SELECT TOP 20 PREDICT(Flowers) AS PredictedSpecies, Species AS ActualSpecies FROM DataMining.IrisDataset;
```

Note that the semicolons at the end are for use in a multiline-style client such as DBeaver or SQuirreL and not part of regular IRIS SQL. See the [QuickML Syntax overview](https://usconfluence.iscinternal.com/display/TBD/QuickML+Syntax) if you want to be more creative. For example, you can add ```USING { 'ml_provider': 'H2O' }``` to your CREATE or TRAIN commands to test the H2O provider instead of the default one.

### Included datasets

These are broadly available datasets, but we may not have permission to _re_-distribute them, so keep this repo to yourself:
- DataMining.IrisDataset: Iris (the flower, not the Gartner MQ ODBMS leader!), as in the classic SAMPLES namespace. You can predict the Species (categorization) or any of the width / length columns (regression)
- Titanic.Passenger: List of all the passengers of the ill-fated bathtub, with a "Survived" column that makes a fun demo target.
- \[SQLUser.\]LoanPerformance: as used at Global Summit, with a "LoanDefault" column that works well for a more serious demo
- \[SQLUser.\]Campaign: as used in the campaign showcase in the [ML Toolkit](https://github.com/intersystems/MLToolkit). The target column to put your crosshairs on is RESPONSE
- \[SQLUser.\]BreastCancer
- \[SQLUser.\]appointments