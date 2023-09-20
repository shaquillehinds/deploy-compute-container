#!/bin/bash

if [ -z $1 ]; then
  echo "Requires parameter image name, this will be used to name the artifact repository."
  exit 1
fi

if [ -z $2 ]; then
  location=us-central1
else
  location=$2
fi

reposList=$(gcloud artifacts repositories list --filter "$1-images")

echo $reposList

if [ -z "${reposList}" ]; then
  echo "No repository found"
  echo "Running: gcloud artifacts repositories create $1-images --repository-format docker --location $location"
  gcloud artifacts repositories create $1-images --repository-format docker --location $location

fi

gcloud auth configure-docker $location-docker.pkg.dev --quiet