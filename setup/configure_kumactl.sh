#!/bin/sh

cp_name=petclinic-cp
cp_url=https://petclinic-cp:5682

#
# Configure kuma-cp
#
if [ ! -f /certs/client/cert.key ]; then
  echo "Generating client certificate"
  kumactl generate tls-certificate --type=client --hostname=${cp_name} --key-file=/certs/client/cert.key --cert-file=/certs/client/cert.pem
  chmod 666 /certs/server/cert.key
  chmod 666 /certs/server/cert.pem
fi
if [ ! -f /certs/server/cert.key ]; then
  echo "Generating server certificate"
  kumactl generate tls-certificate --type=server --cp-hostname=${cp_name} --key-file=/certs/server/cert.key --cert-file=/certs/server/cert.pem
  chmod 666 /certs/server/cert.key
  chmod 666 /certs/server/cert.pem
fi
kumactl config control-planes add --name universal --address ${cp_url} --ca-cert-file /certs/server/cert.pem --client-cert-file /certs/client/cert.pem --client-key-file /certs/client/cert.key --overwrite

