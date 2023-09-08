resource "linode_domain_record" "subdomain" {
  domain_id = var.imported_domain_id
  name = var.subdomain
  record_type = "A"
  target = var.external_ip
}

locals {
  subdomain_id = linode_domain_record.subdomain.id
}

output "id" {
  value = linode_domain_record.subdomain.id
}

output "record_type" {
  value = linode_domain_record.subdomain.record_type
}
