#!/bin/bash
# Source of the jar
CONNECTOR_JAR=gcs-connector-hadoop2-latest.jar
SRC_URL=https://storage.googleapis.com/hadoop-lib/gcs/${CONNECTOR_JAR:?}

# Directories where it will go
PARCELS=/opt/cloudera/parcels
TARGET=$PARCELS/CDH/jars/${CONNECTOR_JAR:?}
HADOOP_DIR=$PARCELS/CDH/lib/hadoop/

# curl the tar file, and link to the hadoop directory
curl -s -l ${SRC_URL:?} --output ${TARGET:?}
sudo ln -s ${TARGET:?} ${HADOOP_DIR}

sudo mkdir -p $PARCELS/GCPSTORAGECONNECTOR-1.0.0/lib/hadoop/lib/;
sudo ln -s $PARCELS/GCPSTORAGECONNECTOR-1.0.0 $PARCELS/GCPSTORAGECONNECTOR;
sudo cp $PARCELS/CDH/jars/gcs-connector-hadoop2-latest.jar $PARCELS/GCPSTORAGECONNECTOR-1.0.0/lib/hadoop/lib/;
sudo ln -s $PARCELS/GCPSTORAGECONNECTOR-1.0.0/lib/hadoop/lib/gcs-connector-hadoop2-latest.jar $PARCELS/CDH/lib/hadoop;
sudo chown -R cloudera-scm:cloudera-scm /opt/cloudera/

# HADOOP_DIR=$PARCELS/CDH/lib/hadoop/
# CONNECTOR_JAR=gcs-connector-hadoop2-latest.jar
# TARGET=$PARCELS/GCPSTORAGECONNECTOR-1.0.0/lib/hadoop/lib/${CONNECTOR_JAR:?}
# sudo mkdir -p $(dirname $TARGET:?})
# sudo ln -s $PARCELS/GCPSTORAGECONNECTOR $PARCELS/GCPSTORAGECONNECTOR-1.0.0
# sudo curl -l ${SRC_URL:?} --output $PARCELS/GCPSTORAGECONNECTOR-1.0.0/lib/hadoop/lib/${CONNECTOR_JAR:?}
# sudo ln -s ${TARGET:?} ${HADOOP_DIR:?}
