#!/bin/bash
set -eux

ZK=$(/bin/ip -o -4 addr show dev docker0|awk '{print $4;}'|cut -f1 -d/;)
AHNAME=localhost
sudo docker network create kafka||true

# Zookeeper
sudo docker run --detach --net=kafka --rm -p 2181:2181 --name zookeeper wurstmeister/zookeeper

# Kafka
sudo docker run \
	--name kafka \
	--net=kafka \
	--env KAFKA_ADVERTISED_HOST_NAME="$AHNAME" \
	--env KAFKA_ZOOKEEPER_CONNECT="$ZK":2181 \
	--env KAFKA_MESSAGE_MAX_BYTES=200000 \
	--env KAFKA_AUTO_CREATE_TOPICS_ENABLE=true \
	-p 9092:9092 \
	-v /opt/tmp/kafka-data:/kafka \
	--rm wurstmeister/kafka
