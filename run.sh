#!/bin/bash

#tail -F -n0 /etc/hosts
#/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --bind_ip 0.0.0.0 --rest --journal

#/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGO_CLUSTER &

#MONGODB_REPLICASET=true
#MONGODB_CLUSTER_NAME=labcluster
#MONGODB_MASTER=true
#MONGODB_ENDPOINTS=mongonode1.example.com:27017,mongonode2.example.com:27017,mongonode3.example.com:27017

#$ADD_DELAY=5

if [ "$MONGODB_REPLICASET" = true ];
then
#   echo "MONGODB_REPLICASET TRUE";
   if [ "$MONGODB_CLUSTER_NAME" != "" ];
   then
       echo "Bootstrapping a replicaset MongoDB cluster..."
	if [ "$MONGODB_MASTER" = true ];
	then
		echo "Bootsrapping a replicaset MongoDB cluster...";
                #/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGODB_CLUSTER_NAME &
                #sleep 5;
		echo "Setting the configurations for replicaset cluster..."

                IFS=',' read -ra ENDPOINTS <<< "$MONGODB_ENDPOINTS"

                echo "Connecting and configuring the first replicaset node... ${ENDPOINTS[0]}"

                #/./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "config= {_id: \"labcluster\",members: [{_id: 0,host: \" ${ENDPOINTS[0]} \"}]};"
                #sleep 5;

                #/./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.initiate(config);"

                #for endpoint in "${ENDPOINTS[@]:1}"; do
                #        echo "Adding endpoint $endpoint to the ReplicaSet..."
                #        /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.add('$endpoint')"
                #        sleep 5;
                #done

                #/./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "printjson(rs.status())"

                #/./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.conf()"

                #/./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-replicaset.js
                #sleep 5;
                echo "Creating default users..."
                #/./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-standalone.js
                #sleep 5;
		echo "Shutting down the server...";
                #/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --shutdown
		#sleep 5;
                echo "Starting replicaset with Auth parameter on...";
                #/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --auth --rest --journal --replSet $MONGODB_CLUSTER_NAME
        else
		echo "Starting SECONDARY node up...";
		#/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --rest --journal --replSet $MONGODB_CLUSTER_NAME
		#sleep 5;
	fi
   else
       echo "ERROR: You need to specify a name for the replicaset configuration! User MONGODB_CLUSTER_NAME=name";
   fi
else
   echo "Bootstrapping up a standalone MongoDB instance...";
   #/./usr/local/mongodb-3.4.2/bin/mongod --rest --journal --config /usr/local/mongodb-3.4.2/mongod.yaml &
   #sleep 5;
   echo "Creating default users...";
   #/./usr/local/mongodb-3.4.2/bin/mongo < /./usr/local/mongodb-3.4.2/init-standalone.js
   #sleep 5;
   echo "Shutting down the server...";
   #/./usr/local/mongodb-3.4.2/bin/mongod --config /usr/local/mongodb-3.4.2/mongod.yaml --shutdown
   #sleep 5;
   echo "Starting instance with Auth parameter on...";
   #/./usr/local/mongodb-3.4.2/bin/mongod --auth --rest --journal --config /usr/local/mongodb-3.4.2/mongod.yaml
fi
