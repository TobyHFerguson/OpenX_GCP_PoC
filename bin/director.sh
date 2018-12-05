set -a
. $(dirname $0)/../cluster.properties

mkdir -p ${SERVER_LOG_DIR:="${HOME}/director-server-logs"}

echo "Director server logs in container will be mounted onto ${SERVER_LOG_DIR}"

docker run \
       --rm \
       --mount "type=volume,source=db,target=/home/director/db" \
       --mount "type=bind,source=${SERVER_LOG_DIR},target=/home/director/logs" \
       ${GOOGLE_APPLICATION_CREDENTIALS:+--mount "type=bind,source=${GOOGLE_APPLICATION_CREDENTIALS},target=${GOOGLE_APPLICATION_CREDENTIALS}"} \
       ${GOOGLE_APPLICATION_CREDENTIALS:+--env GOOGLE_APPLICATION_CREDENTIALS} \
       --name director \
       --network director-network \
       -p 7189:7189 \
       tobyhferguson/cloudera-director:server_latest
