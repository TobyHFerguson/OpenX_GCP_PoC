. $(dirname $0)/../cluster.properties

gcloud compute instances list --filter="name~${PREFIX:?}.*" --format='[table](networkInterfaces[0].accessConfigs[0].natIP,metadata.items[2].value,name)'
