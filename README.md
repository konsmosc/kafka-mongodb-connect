# MongoDB & Kafka Docker end to end example

A simple example that takes JSON documents from the `logs` topic and stores them into the `test.logs` collection in MongoDB using 
the MongoDB Kafka Sink Connector. 

## Requirements
  - Docker 18.09+
  - Docker compose 1.24+
  - *nix system

## Running the example

To run the example: `./run.sh` which will:
  
  - Run `docker-compose up` 
  - Wait for MongoDB, Kafka, Kafka Connect to be ready
  - Register the MongoDB Kafka Sink Connector
  - Write the events to MongoDB  

**Note:** The script expects to be run from within the `docs` directory and requires the whole project to be checked out / downloaded. 

Examine the collections in MongoDB:
  - In your shell run: docker-compose exec mongo1 /usr/bin/mongo
  - Adding, updating data in `test.logs`

## docker-compose.yml

The following systems will be created:

  - Zookeeper
  - Kafka
  - Confluent Kafka Connect
  - MongoDB - a 3 node replicaset

---
### Next

- [Usage guide](https://docs.mongodb.com/kafka-connector/current/)
