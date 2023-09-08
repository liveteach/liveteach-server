# Infrastructure setup
Uses Terraform to configure:
* A subdomain in Linode
* SSL certificates from LetsEncrypt
* Kubernetes namespace
* Image pull secrets to access the container registry

## Pre-requisites
To run these scripts you'll need:
* Docker or Terraform installed
* A built and deployed version of the application you're trying to deploy
* A Kubernetes configuration file providing access to the cluster
* A Linode access token that is capable of configuring the domains

## Configure the insfrastructure
To run these commands you need a `kubeconfig` file in the `terraform` directory. 

Also, set the following environment variables on the command line using `-e` to pass them to the docker run command:
* `TF_VAR_token` = a Linode access token granting permission to edit domains
* `TF_VAR_docker_password` = key providing access to the Docker container registry
* `TF_VAR_database_host`
* `TF_VAR_database_user`
* `TF_VAR_database_password`
* `TF_VAR_database_name`

```bash
cd terraform

docker run -it --rm --name=terraform -v "$PWD":/usr/src/app -w /usr/src/app \
   hashicorp/terraform:latest init
   
docker run -it --rm --name=terraform -v "$PWD":/usr/src/app -w /usr/src/app \
   <environment variables> \
   hashicorp/terraform:latest plan

docker run -it --rm --name=terraform -v "$PWD":/usr/src/app -w /usr/src/app \
   <environment variables> \
   hashicorp/terraform:latest apply
```