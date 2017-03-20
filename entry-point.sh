#!/bin/bash

#tail -F -n0 /etc/hosts
#/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --bind_ip 0.0.0.0 --rest --journal

#/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGO_CLUSTER &

#MONGODB_REPLICASET=false
#MONGODB_REPLICASET=true
#MONGODB_CLUSTER_NAME=labcluster
#MONGODB_MASTER=false

if [ "$MONGODB_REPLICASET" = true ]; 
then
#   echo "MONGODB_REPLICASET TRUE";
   if [ "$MONGODB_CLUSTER_NAME" != "" ];
   then
       echo "Bootstrapping a replicaset MongoDB cluster..." 
	if [ "$MONGODB_MASTER" = true ];
	then
		echo "Bootsrapping a replicaset MongoDB cluster...";
                /./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGODB_CLUSTER_NAME &
                sleep 5;
		echo "Setting the configurations for replicaset cluster..."
                /./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-replicaset.js
                sleep 5;
                echo "Creating default users..."
                /./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-standalone.js
                sleep 5;
		echo "Shutting down the server...";
                /./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --shutdown
		sleep 5;
                echo "Starting replicaset with Auth parameter on...";
                /./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --auth --rest --journal --replSet $MONGODB_CLUSTER_NAME
        else
		echo "Starting SECONDARY node up...";
		/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGODB_CLUSTER_NAME
		sleep 5;
	fi
   else
       echo "ERROR: You need to specify a name for the replicaset configuration! User MONGODB_CLUSTER_NAME=name";
   fi
else
   echo "Bootstrapping up a standalone MongoDB instance...";
   /./usr/local/mongodb-3.4.2/bin/mongod --rest --journal --config /usr/local/mongodb-3.4.2/mongod.yaml &
   sleep 5;
   echo "Creating default users...";	
   /./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-standalone.js
   sleep 5;
   echo "Shutting down the server...";
   /./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --shutdown
   sleep 5;
   echo "Starting instance with Auth parameter on...";
   /./usr/local/mongodb-3.4.2/bin/mongod --auth --rest --journal --config /usr/local/mongodb-3.4.2/mongod.yaml
fi
