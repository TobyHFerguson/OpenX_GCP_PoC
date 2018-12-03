set -a
. $(dirname $0)/../cluster.properties

mkdir -p ${CLIENT_LOG_DIR:="${HOME}/director-client-logs"}

echo "Director client logs in container will be mounted onto ${CLIENT_LOG_DIR}"


client() {
    docker run -it \
	   --rm \
	   -e AWS_ACCESS_KEY_ID \
	   -e AWS_SECRET_ACCESS_KEY \
	   --mount "type=bind,source=${SSH_KEY_PATH:?},target=${SSH_KEY_PATH:?}" \
	   -e SSH_KEY_PATH \
	   -v ${PWD}:/project \
	   --mount "type=bind,source=${CLIENT_LOG_DIR:?},target=/home/director/logs" \
	   --network director-network \
	   tobyhferguson/cloudera-director:client_6.0.0 \
	   ${1:?'No function name provided'}-remote ${2:?'No conf file provided'} \
	   --lp.remote.username=admin \
	   --lp.remote.password=admin \
	   --lp.remote.hostAndPort=director
}
