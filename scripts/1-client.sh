#!/bin/bash

### Colors Variables ###
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color


## Check if verbose mode is activated ##
if [[ "$0" == "-v" ]]; then
    set -x  
fi

echo -e "\n ${GREEN} --------- [Beginning of the Script] --------- ${NC}"

mkdir certs-client

read -p $'\n \e[0;36m --------- What is your API-Gateway common name ? --------- \e[0m' COMMON_NAME

echo -e "\n ${YELLOW} --------- Private key for the certificate authority --------- ${NC}"
openssl genrsa -des3 -out client-rootCA.protected.key 2048
openssl rsa -in client-rootCA.protected.key -out client-rootCA.key

echo -e "\n ${YELLOW} --------- Generate the CA --------- ${NC}"
openssl req -x509 -new -nodes -key client-rootCA.key -sha256 -days 1024 -out client-rootCA.pem -subj "/C=US/ST=California/L=Mountain View/O=client-orga/OU=client-unit/CN=${COMMON_NAME}"

echo -e "\n ${YELLOW} --------- Generate a key for the client certificate --------- ${NC}"
openssl genrsa -out client.key 2048

echo -e "\n ${YELLOW} --------- Generate the certificate request for the client --------- ${NC}"
openssl req -new -key client.key -out client.csr -subj "/C=US/ST=California/L=Mountain View/O=client-orga/OU=client-unit/CN=${COMMON_NAME}"

echo -e "\n ${YELLOW} --------- Sign the certificate request for the client --------- ${NC}"
openssl x509 -req -in client.csr -extensions client -CA client-rootCA.pem -CAkey client-rootCA.key -CAcreateserial -out client.crt -days 500 -sha256

mv client* certs-client/

echo -e "\n  ${GREEN}--------- [End of the Script] --------- ${NC}"
