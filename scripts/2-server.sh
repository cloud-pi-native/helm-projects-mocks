#!/bin/bash

### Colors Variables ###
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

## Check if verbose mode is activated ##
if [[ "$1" == "-v" ]]; then
    set -x
fi

## Start ##

echo -e "\n ${GREEN} --------- [Beginning of the Script] --------- ${NC}"


mkdir server-certs

echo -e "\n ${YELLOW} --------- Generate a key for the server certificate --------- ${NC}"
openssl genrsa -out krakend-server.key 2048

echo -e "\n ${YELLOW} --------- Generate the certificate request for the server--------- ${NC}"
openssl req -new -key krakend-server.key -out krakend-server.csr -subj "/C=US/ST=California/L=Mountain View/O=krakend-orga/OU=krakend-unit/CN=krakend"

echo -e "\n ${YELLOW} --------- Sign the certificate request for the server --------- ${NC}"
openssl x509 -req -in krakend-server.csr -extensions server -CA certs-client/client-rootCA.pem -CAkey certs-client/client-rootCA.key -CAcreateserial -out krakend-server.crt -days 500 -sha256

echo -e "\n ${YELLOW} --------- Generate Kubernetes krakend secret --------- ${NC}"
kubectl create secret generic krakend-tls-secret --from-file=certs-client/client-rootCA.pem --from-file=krakend-server.crt --from-file=krakend-server.key --dry-run=client -oyaml > krakend-tls-secret.yaml

mv krakend* server-certs/

echo -e "\n  ${GREEN}--------- [End of the Script] --------- ${NC}"
