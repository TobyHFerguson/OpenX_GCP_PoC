#!/bin/sh
# Copy the given key to the workers
#
source cluster.properties

readonly KEY_FILE=${1:?"No gcp key given"}

[ -r $KEY_FILE ] || { echo "GCP Key file ($KEY_FILE) not readable" 1>&2; }

for host in $(gcloud compute instances list --filter="name~^${PREFIX:?}.*" --format="[table](networkInterfaces[0].accessConfigs[0].natIP)" | tail +2)
do
    scp -i ${SSH_KEY_PATH:?} ${KEY_FILE:?} ${SSH_USERNAME}@$host:/tmp/gcp-sa.json
    ssh -i ${SSH_KEY_PATH:?} ${SSH_USERNAME}@$host '[ -f /opt/cloudera/parcels/CDH/jars/gcs-connector*.jar ] && sudo mv -f /tmp/gcp-sa.json /opt/cloudera'
done
