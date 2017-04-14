# clustered-mongodb-docker-image
A clustered mongoDB docker image allows you spinning up a mongoDB cluster in a few seconds.

# Technologies used in this project

- Shell script
- Docker

# Setting up this project locally

> **Note:**
The fastest way to get this application up and running locally is using **Docker**.  Be sure that you have at least **Docker 1.13.0** installed on your machine.

1. Clone this repository
```shell
$ git clone https://github.com/godois/clustered-mongodb-docker-image.git
```
2. Building the local image

You should execute the follow command in the project directory

```shell
$ docker build -t localhost/mongodb-clustered:1.0 .
```

### Bootstrapping a SINGLE NODE mongodb

You will need to run the follow steps to run a single node mongodb. 

First, create a network in case of you need to communicate to another container. The name of the network defined is mongodb-net

```shell
$ docker network create --subnet=192.170.0.0/16 mongodb-net
```

So, run the following command:

```shell
$ docker run -d -it \
      --name mongodb-singlenode \
      --hostname="mongonode1.example.com" \
      --ip 192.170.1.1 \
      --net mongodb-net \
      -p 27017:27017 -p 28017:28017 \
      -e MONGODB_REPLICASET=false \
      -e MONGODB_MASTER=false \
      -e MONGODB_CLUSTER_NAME=false \
      -e MONGODB_ENDPOINTS=false \
      -v /tmp/mongodb-master/data:/opt/mongodb/data \
      -v /tmp/mongodb-master/log:/opt/mongodb/log \
      godois/mongodb-clustered:1.0
```

Explaining docker run parameters:

* <b> --name </b> - it defines the container name.
* <b> --hostname </b> - it sets up the hostname that will be visible to the network.
* <b> --ip </b> - it sets up the ip that will be visible to the network.
* <b> --net </b> - it defines the network which this container will be part of.
* <b> --p </b> - it binds the container port to the host port.
* <b> --p </b> - it binds the container port to the host port.