#!/bin/bash

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
  echo "Missing parameters, parameter 1 must be instance name, 2 must be then instance zone, 3 must be the container image. Paramter 4 is optional and that is container env vars, e.g PORT=3001,NODE_ENV=production"
  exit 1
fi

if [ -z $4 ]; then
  machine_type=e2-micro
else
  machine_type=$4
fi

instancesList=$(gcloud compute instances list --filter "name=('$1')")

echo $instancesList

if [ -z "${instancesList}" ]; then

  echo "No instance found"
  echo "Running: gcloud compute instances create-with-container $1 --zone=$2 --container-image=$3 --machine-type=$machine_type --tags=http-server,https-server --container-env=$5"

  gcloud compute instances create-with-container $1 --zone=$2 --container-image=$3 --machine-type=$machine_type --tags=http-server,https-server --container-env=$5

else 

  echo "Instance found"
  ecno "Running: gcloud compute instances update-container $1 --zone=$2 --container-image=$3 --container-env=$5"

  gcloud compute instances update-container $1 --zone=$2 --container-image=$3 --container-env=$5
fi