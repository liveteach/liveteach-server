# Kubernetes service setup
Uses Helm to configure Kubernetes components required to run a server:
* Ingress, using the SSL certificate configured in Terraform
* Network service
* Deployment configuration describing the service, image and configuration

## Pre-requisites
To run these scripts you'll need:
* kubectl installed
* helm installed
* A Kubernetes configuration file providing access to the cluster

## Configure the insfrastructure
To run these commands you need a `kubeconfig` file.  

```bash
set KUBECONFIG=<kubeconfig file>
helm install <appname> ./helm --set ingress.enabled=true --namespace <app namespace>
```

Or dry run in Docker using:

```bash
docker run --rm -w /apps -v $(pwd):/apps -e KUBECONFIG=./kubeconfig alpine/k8s:1.20.7 helm upgrade breadcrumb-service ./helm --dry-run --install -f ./helm/values.uat.yaml --set ingress.enabled=true --namespace breadcrumb-service
```