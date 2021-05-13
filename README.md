# Fluentd & MongoDB & Kafka Docker example

A simple example that takes docker logs from containers `stdout` sends them in the `topic` topic of Kafka broker and stores them into the `test.logs` collection in MongoDB using 
the MongoDB Kafka Sink Connector. 

## Requirements
  - Docker 18.09+
  - Docker compose 1.24+
  - *nix system

## Running the example

To run the example: `./run.sh` which will:
  
  - Run `docker-compose up` 
  - Wait for Fluentd, MongoDB, Kafka, Kafka Connect to be ready
  - Register the MongoDB Kafka Sink Connector
  - Write the events to MongoDB  

**Note:** The script expects to be run and requires the whole project to be checked out / downloaded. 

Examine the collections in MongoDB:
  - Use Mongo-express client in `http://localhost:8081` to monitor the mongodb documents

## docker-compose.yml

The following systems will be created:

  - Fluentd
  - Zookeeper
  - Kafka
  - Confluent Kafka Connect
  - MongoDB - a 3 node replicaset
  - Mongo-Express

---
### Next

- [Usage guide](https://docs.mongodb.com/kafka-connector/current/)
