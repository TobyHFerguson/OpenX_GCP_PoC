. $(dirname $0)/.director-client.sh

$(basename $0 .sh)() { client ${FUNCNAME[0]} ${1:?'No conf file provided'} ;}

$(basename $0 .sh) $1
