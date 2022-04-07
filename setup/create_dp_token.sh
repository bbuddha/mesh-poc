#!/bin/sh


# Exit immediately if a command exits with a non-zero status
set -e

#
# Create token for "${dataplane}"
#
create_dataplane_token() {
  dataplane="$1"
  echo "Generating dataplane token to '${dataplane}'/token"
  kumactl generate dataplane-token --name="${dataplane}" > /"${dataplane}"/token
}

/petclinic/configure_kumactl.sh

#
# Create dataplane-token for customers service
#
create_dataplane_token "customers-service"

#
# Create dataplane-token for visits service
#
create_dataplane_token "visits-service"

#
# Create dataplane-token for vets service
#
create_dataplane_token "vets-service"

#
# Create dataplane-token for vets service v2
#
create_dataplane_token "vets-service-v2"

#
# Create dataplane-token for offers service
#
create_dataplane_token "offers-service"

#
# Create dataplane-token for application api-gateway service
#
create_dataplane_token "api-gateway"

#
# Create dataplane-token for mesh-gateway service
#
create_dataplane_token "mesh-gateway"

echo "Dataplane token generation complete."

