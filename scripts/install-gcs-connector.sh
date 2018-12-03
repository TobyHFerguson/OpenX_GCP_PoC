#!/bin/bash
# Source of the jar
CONNECTOR_JAR=gcs-connector-hadoop2-latest.jar
SRC_URL=https://storage.googleapis.com/hadoop-lib/gcs/${CONNECTOR_JAR:?}

# Directories where it will go
TARGET=/opt/cloudera/parcels/CDH/jars/${CONNECTOR_JAR:?}
HADOOP_DIR=/opt/cloudera/parcels/CDH/lib/hadoop/

# curl the tar file, and link to the hadoop directory
curl -l ${SRC_URL:?} --output ${TARGET:?}
sudo ln -s ${TARGET:?} ${HADOOP_DIR}
