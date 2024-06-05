variable "domain" {
  type = string
  description = "The domain to create the SES identity for."
}

variable "zone_id" {
  type    = string
  description = "Route53 parent zone ID."
  default = ""
}

variable "verify_domain" {
  type    = bool
  description = "If true the module will create Route53 DNS records used for domain verification."
  default = false
}

variable "verify_dkim" {
  type    = bool
  description = "If true the module will create Route53 DNS records used for DKIM verification."
  default = false
}

variable "create_spf_record" {
  type    = bool
  description = "If true the module will create an SPF record for `domain`."
  default = false
}

variable "mail_from_domain" {
  type     = string
  description = "If provided the module will create a custom subdomain for the `MAIL FROM` address."
  default  = null
  nullable = true

  validation {
    condition     = var.mail_from_domain != null ? can(regex("^[a-zA-Z0-9-]+$", var.mail_from_domain)) : true
    error_message = "The mail_from_domain must be subdomain of the primary domain."
  }
}