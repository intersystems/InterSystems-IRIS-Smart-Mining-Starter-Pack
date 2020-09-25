Use image aspmining-0.4.2 or you will need to manually enable IAM user and IAM app

Setup the image
```
cd IAM/scripts
source unix/iam-setup.sh
docker-compose up -d
```

Create the Service and route

```
# Replace 192.168.0.4:52773 by your iris instance and port
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=iris' \
  --data 'url=http://192.168.0.4:52773'

#Add route
curl -i -X POST \
  --url http://localhost:8001/services/iris/routes \
  --data 'hosts[]=192.168.0.4'
```

Test 
```
curl -i -X POST \
  --url http://SuperUser:sys@192.168.0.4:8000/MDX2JSON/MDX?Namespace=APPINT \
  --header 'Host: 192.168.0.4' \
  --header 'Authorization: Basic U3VwZXJVc2VyOnN5cw=='
# Must return an erro about the cube, but that is expected.
```

TODO: Adding OAuth 2.0