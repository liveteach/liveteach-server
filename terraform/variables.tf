variable "token" {
  description = "Your Linode API Personal Access Token. (required)"
  sensitive = true
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type = list(string)
}

variable "email" {
  default = "systems@vegascity.org"
}

variable "region" {
  description = "Linode region for the DB cluster"
  default = "eu-west"
}

variable "docker_username" {
  default = "paulfvegascity"
  description = "Username used to access the Docker container registry"
}

variable "docker_password" {
  description = "Key used to access the Docker container registry"
  sensitive = true
}

variable "docker_server" {
  description = "Docker container registry, Docker Hub default"
  default = "https://index.docker.io/v1/"
}

variable "kubeconfig_path" {
  description = "Path to the LKE kubeconfig file"
}

variable "letsencrypt_url" {
  description = "URL for Letsencrypt certificates"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "domain" {
  description = "Domain name"  
}

variable "subdomain" {
  description = "Subdomain for the service, <subdomain>.<domain>"
}

variable "imported_domain_id" {
  description = "Variable used to import the domain ID"
}

variable "external_ip" {
  description = "External IP address of the cluster"
}

variable "app_name" {
  description = "Name of the app"
}

# New MongoDB infrastructure variables
variable "mongo_db_protocol" {
  default = "mongodb+srv"
}

variable "mongo_db_host" {
  description = "MongoDB Atlas host"
  default = "none"
}

variable "mongo_db_instance_name" {
  description = "Database instance name in MongoDB"
  default = "breadcrumbsdb"
}

variable "mongo_db_user" {
  description = "DB username"
  default = "none"
}

variable "mongo_db_read_only_user" {
  description = "Read only DB username"
    default = "none"
}

variable "mongo_db_tls" {
  default = true
}

variable "mongo_dbatlas_public_key" {
  description = "Public key for accessing MongoDB Atlas, used for creating database users"
}

variable "mongo_dbatlas_private_key" {
  description = "Private key for accessing MongoDB Atlas, used for creating database users"
}

variable "mongo_db_project_id" {
  description = "MongoDB Atlas project ID"
  default = "none"
}

variable "mongo_db_cluster_name" {
  description = "Cluster name in MongoDB Atlas - different for production and UAT"
  default = "none"
}