. $(dirname $0)/../cluster.properties

# Use jq to number the different roles

#PREFIX=${1:?"No name prefix supplied"}
gcloud compute instances list --filter="name~^${PREFIX}.*" --format="[table,no-heading](metadata.items[2].value:sort=1,networkInterfaces[0].accessConfigs[0].natIP)" |
    sed 's/\(.*\)  \(.*\)/Host '${PREFIX:?}'-\1 \
	Hostname \2/g'

cat <<EOF

Match originalhost=${PREFIX:?}*
    StrictHostKeyChecking no
    CheckHostIP no
    User toby
    IdentityFile ${SSH_KEY_PATH:?}

EOF
