resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "${var.subdomain}.${var.domain}"

  dns_challenge {
    provider = "linode"

    config = {
      LINODE_TOKEN = var.token
    }
  }
}

# Put them into Kubernetes
resource "kubernetes_secret" "tls_secrets" {
  metadata {
    name = "tls-secret"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
  }
  data = {
    "tls.crt" = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    "tls.key" = acme_certificate.certificate.private_key_pem
  }
  type = "kubernetes.io/tls"
}
