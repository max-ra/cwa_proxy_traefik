#!/bin/bash
#Setup developement environment for MFR CWA project

#Settings
TargetProxy="/srv/cwa_traefik/traefik/"
TargetDomain=rauch.lan
Subdomains=(mail.dev wiki auth pad intern docker cloud openproject inventory scm)
TargetSubject="/C=DE/ST=BY/O=Rauch Internal DEVELOPEMENT/OU=IT"

# clean proxy security
sudo rm -rf ${TargetProxy}certs/*
sudo rm -rf ${TargetProxy}dhparm/*

if [ -d "devCA" ]; then
  sudo rm -rf devCA/*
else
  mkdir devCA
fi

# Update root CA
openssl genrsa -out devCA/$TargetDomain.DEV.key 4096
openssl req -x509 -new -nodes -key devCA/$TargetDomain.DEV.key -sha512 -days 60 -subj "${TargetSubject}/CN=$TargetDomain" -out devCA/$TargetDomain.DEV.pem -extensions v3_ca

createServerKey () {
  openssl genrsa -out devCA/$1.$TargetDomain.DEV.key 4096
}

createServerCertificate () {
  #create subjectAltName ext file
  echo "subjectAltName = DNS:$1.${TargetDomain}" > SAN.ext

  openssl req -new -key devCA/$1.$TargetDomain.DEV.key  -addext "subjectAltName=DNS:$1.${TargetDomain}" -subj "${TargetSubject}/CN=$1.$TargetDomain" -out devCA/$1.$TargetDomain.DEV.req
  openssl x509 -req -days 30 -in devCA/$1.$TargetDomain.DEV.req -CA devCA/$TargetDomain.DEV.pem -CAkey devCA/$TargetDomain.DEV.key -CAcreateserial -out devCA/$1.$TargetDomain.DEV.pem -extfile SAN.ext

  cat devCA/$TargetDomain.DEV.pem >> devCA/$1.$TargetDomain.DEV.pem

  #remove SAN file
  rm SAN.ext
}

deployServerCertificate () {
  cp devCA/$1.$TargetDomain.DEV.key ${TargetProxy}certs/$1.$TargetDomain.key
  cp devCA/$1.$TargetDomain.DEV.pem ${TargetProxy}certs/$1.$TargetDomain.crt
}


for domain in "${Subdomains[@]}"
do
  createServerKey $domain
  createServerCertificate $domain
  deployServerCertificate $domain
done
