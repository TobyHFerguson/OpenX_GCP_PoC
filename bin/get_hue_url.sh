ENVIRONMENT=ox
DEPLOYMENT=ox
CURL="curl --silent --user admin:admin"
CM_IP_PORT=$(${CURL} -X GET "http://localhost:7189/api/d6.0/environments/${ENVIRONMENT}/deployments/${DEPLOYMENT}" -H "accept: application/json" |
	    jq -r '.managerInstance.properties.publicIpAddress+":"+(.port | tostring)' )
HUE_SERVICE_NAME=$(${CURL} http://${CM_IP_PORT:?}/api/v19/clusters/${DEPLOYMENT:?}/services | 
    jq -r '.items| .[]| select(.type=="HUE") | .name')
HUE_HOSTID=$(${CURL} http://${CM_IP_PORT:?}/api/v19/clusters/${DEPLOYMENT:?}/services/${HUE_SERVICE_NAME:?}/roles |
    jq -r '.items | . [] | .hostRef.hostId')
HUE_HOSTIP=$(${CURL} http://${CM_IP_PORT:?}/api/v19/hosts |
		 jq -r --arg ID "${HUE_HOSTID}" '.items | .[] | select(.hostId==$ID) | .ipAddress')

# Gcloud format
# networkInterfaces[0].accessConfigs[0].natIP:       35.199.181.228
# networkInterfaces[0].accessConfigs[0].networkTier: PREMIUM
# networkInterfaces[0].accessConfigs[0].type:        ONE_TO_ONE_NAT
# networkInterfaces[0].fingerprint:                  kBqTwFq9cyI=
# networkInterfaces[0].kind:                         compute#networkInterface
# networkInterfaces[0].name:                         nic0
# networkInterfaces[0].network:                      https://www.googleapis.com/compute/v1/projects/gcp-se/global/networks/fcecomp-vpc
# networkInterfaces[0].networkIP:                    10.240.0.11

HUE_IP=$(gcloud compute instances list --filter="networkInterfaces[0].networkIP=${HUE_HOSTIP}" --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

HUE_PORT=8888
echo http://${HUE_IP:?}:${HUE_PORT:?}


