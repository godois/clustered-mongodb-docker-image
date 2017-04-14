#!/bin/bash

# Entry-point script for clustered-mongodb docker image.
# MONGODB_REPLICASET = it allows you to bootstrap a replicaset cluster of mongodb (true/false). Ex: export MONGODB_REPLICASET=true
# MONGODB_CLUSTER_NAME = it allows you to set a name for your mongodb cluster. Ex: export MONGODB_CLUSTER_NAME=labcluster
# MONGODB_MASTER = true whether you want to set this node master, false for non master nodes
# MONGODB_ENDPOINTS = if you set MONGODB_REPLICASET=true and MONGODB_CLUSTER_NAME with a value, then, you should set this variable with the addresses
# for the cluster members


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

            IFS=',' read -ra ENDPOINTS <<< "$MONGODB_ENDPOINTS"

            echo "Connecting and configuring the first replicaset node... ${ENDPOINTS[0]}"

            STRING_CONFIG="config= {_id: \"labcluster\",members: [{_id: 0,host:\"${ENDPOINTS[0]}\"}]};";

            /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval ${STRING_CONFIG}
            sleep 5;

            /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.initiate(config);"

            for endpoint in "${ENDPOINTS[@]:1}"; do
                echo "Adding endpoint $endpoint to the ReplicaSet..."
                /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.add('$endpoint')"
                sleep 5;
            done

            /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "printjson(rs.status())"

            /./usr/local/mongodb-3.4.2/bin/mongo ${ENDPOINTS[0]} --eval "rs.conf()"
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
            #sleep 5;
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
