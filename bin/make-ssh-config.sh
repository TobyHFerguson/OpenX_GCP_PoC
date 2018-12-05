. $(dirname $0)/../cluster.properties

# Use jq to number the different roles

#PREFIX=${1:?"No name prefix supplied"}
# Hosts by role is an array with the 0,2,4 etc. being keys, and the 1,3,5 etc being values
# The keys are in the set {cm,gateway,master,worker} and are sorted

hosts_by_role=($(gcloud compute instances list --filter="name~^${PREFIX}-.*" --format="[csv,no-heading](metadata.items[2].value:sort=1,networkInterfaces[0].accessConfigs[0].natIP)"))

# These arrays are the 'role' arrays - the contents of each array are the ip addresses for each role
declare -a cm
declare -a gateway
declare -a master
declare -a worker

# parse the hosts by role array to create the role arrays
function parse_hosts(){
    while [ $# -ne 0 ]
    do
	case $1 in
	    cm) cm+=($2);;
	    gateway) gateway+=($2);;
	    master) master+=($2);;
	    worker) worker+=($2);;
	    *) Unknown key: $1 1>&2;; 
	esac
	shift; shift
    done
}

# Make an entry for ssh_config given a hostname and an ip address
function make_entry() {
    cat <<EOF
Host $1
     Hostname $2
EOF
}

# make_entries name addresses
# For each address create an ssh config entry, suffixing the name with the address index to disambiguate
function make_entries() {
    name=${PREFIX:?}-${1:?"No name given"}
    shift
    if [ $# -eq 1 ]
    then
	make_entry $name $1
    else
	i=0
	while [ $# -ne 0 ]
	do
	    make_entry ${name}${i} $1
	    shift
	    i=$((i + 1))
	done
    fi
}

parse_hosts ${hosts_by_role[*]}
make_entries cm ${cm[*]}
make_entries gateway ${gateway[*]}
make_entries master ${master[*]}
make_entries worker ${worker[*]}

cat <<EOF

Match originalhost=${PREFIX:?}-*
    StrictHostKeyChecking no
    CheckHostIP no
    User toby
    IdentityFile ${SSH_KEY_PATH:?}

EOF
