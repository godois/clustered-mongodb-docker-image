############################################################
# Dockerfile to build MongoDB 3.4.2 environment 
# Based on baseImage
############################################################

# Set the base image to base:1.0
FROM ubuntu:trusty

# File Author / Maintainer
MAINTAINER Marcio Godoi <souzagodoi@gmail.com>

USER root

RUN apt-get update && \
    apt-get install -y \
    wget \
   	tar \
	less \
	git \
	curl \
	vim \
	wget \
	unzip \
	netcat \
	software-properties-common \
	telnet

# Download Mongodb binary file and extract it to a folder
RUN wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.4.2.tgz -P /tmp/mongodb && \
  tar -xvzf /tmp/mongodb/mongodb-linux-x86_64-ubuntu1404-3.4.2.tgz -C /tmp/mongodb && \
  mv /tmp/mongodb/mongodb-linux-x86_64-ubuntu1404-3.4.2 /usr/local/mongodb-3.4.2 && \
  rm -rf /tmp/mongodb

# Creates directory used to store the data files
RUN mkdir -p /opt/mongodb/data

# Creates directory used to store the log files
RUN mkdir -p /opt/mongodb/log

# Set an environment variable with a mongodb root directory
ENV MONGOPATH /usr/local/mongodb-3.4.2

# Add to a mongodb root directory the config file
ADD mongod.yaml $MONGOPATH

# This init-standalone.js file is used to setup the admin user at the moment to startup the container
ADD init-standalone.js $MONGOPATH

# This init-replicaset.js file is used to setup the replicaset cluster at the moment to startup the containers
ADD init-replicaset.js $MONGOPATH

# Put the entrypoint file into the MongoDB directory
ADD run.sh $MONGOPATH/bin/entry-point.sh

# Allows the Entrypoint file to execute as a shell 
RUN chmod 755 $MONGOPATH/bin/entry-point.sh

# Expose the connection port to the host
EXPOSE 27017

# Expose the rest port to the host
EXPOSE 28017

# Set the entrypoint file
ENTRYPOINT ["run.sh"]