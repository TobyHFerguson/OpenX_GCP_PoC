. $(dirname $0)/.director-client.sh

validate() { client ${FUNCNAME[0]} ${1:?'No conf file provided'} ;}

validate $1
