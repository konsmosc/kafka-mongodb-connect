#!/bin/bash

echo "Starting docker ."
docker-compose up -d --build

sleep 5
echo -ne "\n\nWaiting for the systems to be ready.."
function test_systems_available {
  COUNTER=0
  until $(curl --output /dev/null --silent --head --fail http://localhost:$1); do
      printf '.'
      sleep 2
      let COUNTER+=1
      if [[ $COUNTER -gt 30 ]]; then
        MSG="\nWARNING: Could not reach configured kafka system on http://localhost:$1 \nNote: This script requires curl.\n"

          if [[ "$OSTYPE" == "darwin"* ]]; then
            MSG+="\nIf using OSX please try reconfiguring Docker and increasing RAM and CPU. Then restart and try again.\n\n"
          fi

        echo -e $MSG
        clean_up "$MSG"
        exit 1
      fi
  done
}

test_systems_available 8083

echo -e "\nConfiguring the MongoDB ReplicaSet.\n"
docker-compose exec mongo1 /usr/bin/mongo --eval '''if (rs.status()["ok"] == 0) {
    rsconf = {
      _id : "rs0",
      members: [
        { _id : 0, host : "mongo1:27017", priority: 1.0 },
        { _id : 1, host : "mongo2:27017", priority: 0.5 },
        { _id : 2, host : "mongo3:27017", priority: 0.5 }
      ]
    };
    rs.initiate(rsconf);
}

rs.conf();'''


echo -e "\nKafka Connectors:"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

sleep 5

echo -e "\nAdding MongoDB Kafka Sink Connector for the 'topic' topic into the 'test.logs' collection:"
curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink",
   "config": {
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "tasks.max":"1",
     "topics":"topic",
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "database":"test",
     "collection":"logs",
     "key.converter": "org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable": "false",
     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable": "false"
}}' http://localhost:8083/connectors -w "\n"

sleep 2
echo -e "\nKafka Connectors: \n"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

echo "Looking at data in 'db.test':"
docker-compose exec mongo1 /usr/bin/mongo --eval 'db.test.find()'


echo -e '''

==============================================================================================================
DONE!
==============================================================================================================

'''
