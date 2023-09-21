# Deploy Compute Container

## Description

Builds the docker image from the dockerfie in this repository and deploys it to GCP Compute Engine as a container using artifact registry

## Example

```
name: Build And Deploy Staging Image

on:
  push:
    branches: ['staging']
  pull_request:
    branches: ['staging']

env:
 IMAGE_NAME: my-image

jobs:
  buildAndDeploy:
    runs-on: ubuntu-latest
    steps:
      - uses: shaquillehinds/deploy-compute-container@v0.1.2
        with:
          project_id: my-project-id
          image_name: $IMAGE_NAME
          compute_instance_name: my-instance-staging
          compute_zone: us-central1-a
          service_account_json_key: ${{secrets.SERVICE_ACCOUNT_KEY}}
          instance_container_env: PORT=3001,NODE_ENV=production
          docker_build_command: docker build -t $IMAGE_NAME:latest .
```

## Required Inputs

- project_id
  - description: The GCP project id for your container
  - required: true
- image_name:
  - description: The name of the inage you want to deploy
    -required: true
- compute_instance_name:
  - description: The name of the instance you're deploying to
  - required: true
- compute_zone:
  - description: The compute zone of the instance you're deploying to
  - required: true
- docker_build_command:
  - description: Enter you docker build command here
  - required: true
- image_tag:
  - description: (Optional) A custom tage for your image
  - default: ${{github.sha}}
- service_account_json_key:
  - description: The service account JSON key to allow github to perform actions on gcp on your behalf
  - required: true
- instance_ssh_private_key:
  - description: The ssh private key to the instance or project if the instance allows project wide keys
- machine_type:
  - description: Specifies the machine type used for the instances. To get a list of available machine types, run 'gcloud compute machine-types list'. If unspecified, the default type is n1-standard-1
  - default: e2-micro
- instance_container_env:
  - description: Any environment variables you want to pass to the instance. These won't be available on the build phase, only when the container is mounted as an instance. e.g PORT=3001,NODE_ENV=production
- artifact_registry_location:
  - description: The location of the artifact registry
  - default: us-central1

### This action requires you to have a service account json key to work and the service account must have Storage Admin, Compute Admin and IAP=secured Tunnel User permissions. I might automate this later, who knows.

1. Create a service account with roles of Storage Admin, Artifact Registry Administrator, Compute Admin and IAP-secured Tunnel User
2. Generate and download a json key for that service account
3. Edit your compute engine default service account and grant access to your new service account with the role Service Account User
4. Go to the project of this workflow on github. Settings > Secrets & Variables > Actions
5. Create a new repository secret for the service account key, something like SERVICE_ACCOUNT_KEY
6. Create a new ssh pair (ssh-keygen -b 2048 -t rsa)
7. Add the private key to your project as a secret (id_rsa), something like GCP_SSH_PRIVATE_KEY
8. Add the public key to your project or instance (id_rsa.pub)
