. $(dirname $0)/.director-client.sh

bootstrap() { client ${FUNCNAME[0]} ${1:?'No conf file provided'} ;}

bootstrap $1
