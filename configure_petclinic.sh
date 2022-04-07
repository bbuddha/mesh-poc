#!/bin/sh


set -e

#
# Utility functions
#

resolve_ip() {
  getent hosts "${hostname}" 2>/dev/null | awk -e '{ print $1 }'
}

fail() {
  printf 'Error: %s\n' "${1}" >&2  ## Send message to stderr. Exclude >&2 if you don't want it that way.
  exit "${2-1}"                    ## Return a code specified by $2 or 1 by default.
}

create_dataplane() {
  hostname="$1"
  public_port=$2
  local_port=$3
  resource="$4"
  dataplane="${hostname}"

  echo "create_dataplane ${dataplane} using hostname=${1}, public=${2}, local=${3}, resource='${4}'"

  #
  # Create token for "${dataplane}"
  #
  echo "generating dataplane token to '${dataplane}'/token"
  kumactl generate dataplane-token --name="${dataplane}" > /"${dataplane}"/token

  #
  # Resolve IP address allocated to the "${dataplane}" container
  #
  dataplane_ip=$( resolve_ip "${hostname}" )
  if [ -z "${dataplane_ip}" ]; then
    fail "failed to resolve IP address allocated to the '${hostname}' container"
  fi
  echo "'${hostname}' has the following IP address: ${dataplane_ip}"

  #
  # Create Dataplane for "${dataplane}"
  #
  echo "${resource}" | kumactl apply -f - \
    --var IP="${dataplane_ip}" \
    --var PUBLIC_PORT="${public_port}" \
    --var LOCAL_PORT="${local_port}" \
    --var NAME="${hostname}"

}

create_mesh_gateway() {
  hostname="$1"
  resource="$2"
  ip_addr=$( resolve_ip "${hostname}" )

  echo "create_dataplane hostname=${1}, resource='${2}'"

  if [ -z "${ip_addr}" ]; then
      fail "failed to resolve IP address allocated to the '${hostname}' container"
  fi
  echo "'${hostname}' has the following IP address: ${ip_addr}"

  echo "${resource}" | kumactl apply -f - \
      --var IP="${ip_addr}" \
      --var NAME="${hostname}"

  kumactl generate dataplane-token --name="${hostname}" > /"${hostname}"/token
}

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

#
# Create kuma-dp for customers service
#
create_dataplane "customers-service" 8081 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: {{ NAME }}
        kuma.io/protocol: http
"

#
# Create kuma-dp for visits service
#
create_dataplane "visits-service" 8082 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: {{ NAME }}
        kuma.io/protocol: http
"

#
# Create kuma-dp for vets service
#
create_dataplane "vets-service" 8083 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: {{ NAME }}
        kuma.io/protocol: http
        version: v1
  outbound:
    - port: 10000
      tags:
        kuma.io/service: offers-service
"

#
# Create kuma-dp for vets service v2
# Notice kuma.io/service is explicitly set so v1 and v2
#
create_dataplane "vets-service-v2" 8084 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: vets-service
        kuma.io/protocol: http
        version: v2
  outbound:
    - port: 10000
      tags:
        kuma.io/service: offers-service
"

#
# Create kuma-dp for offers service
#
create_dataplane "offers-service" 8085 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: {{ NAME }}
        kuma.io/protocol: http
"

#
# Create kuma-dp for application api-gateway service
#
create_dataplane "api-gateway" 8000 80 "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  admin:
    port: 9901
  address: {{ IP }}
  inbound:
    - port: {{ PUBLIC_PORT }}
      servicePort: {{ LOCAL_PORT }}
      tags:
        kuma.io/service: {{ NAME }}
        kuma.io/protocol: http
  outbound:
    - port: 10000
      tags:
        kuma.io/service: customers-service
    - port: 10001
      tags:
        kuma.io/service: visits-service
    - port: 10002
      tags:
        kuma.io/service: vets-service
"

create_mesh_gateway "mesh-gateway" "
type: Dataplane
mesh: default
name: {{ NAME }}
networking:
  address: {{ IP }}
  gateway:
    type: BUILTIN
    tags:
      kuma.io/service: {{ NAME }}"

kumactl apply -f /petclinic/policies/mesh-gateway.yml
kumactl apply -f /petclinic/policies/mesh-gateway-route.yml
kumactl apply -f /petclinic/policies/allow-traffic-defaults.yml

