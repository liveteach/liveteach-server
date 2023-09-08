provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "acme" {
  server_url = var.letsencrypt_url
}

provider "linode" {
  token = var.token
}

### Linode MongoDB config
provider "mongodb" {
  host = linode_database_mongodb.breadcrumbs_mongodb.host_primary
  port = linode_database_mongodb.breadcrumbs_mongodb.port
  username = linode_database_mongodb.breadcrumbs_mongodb.root_username
  password = linode_database_mongodb.breadcrumbs_mongodb.root_password
  auth_database = "admin"
  ssl = true
  certificate = linode_database_mongodb.breadcrumbs_mongodb.ca_cert
  # replica_set = "replica-set" #optional
  # retrywrites = false # default true
  # direct = true // default false 
}
###

provider "mongodbatlas" {
  public_key = var.mongo_dbatlas_public_key
  private_key  = var.mongo_dbatlas_private_key
}

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.4"
    }
    acme = {
      source = "vancluever/acme"
      version = "~> 2.9"
    }
    mongodb = {
      source = "Kaginari/mongodb"
      version = "0.1.5"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.9.0"
    }
  }
}
