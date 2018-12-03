
PREFIX=${1:?"No name prefix supplied"}
gcloud compute instances list --filter="name~^${PREFIX}.*" --format="[table](name:sort=1,networkInterfaces[0].accessConfigs[0].natIP)" |
    grep "${PREFIX:?}" |
    sed 's/\(.*\)  \(.*\)/Host \1 \
	Hostname \2/g'

cat <<EOF

Match originalhost=${PREFIX:?}*
    StrictHostKeyChecking no
    CheckHostIP no
    User toby
    IdentityFile ${SSH_KEY_PATH:?}

EOF
