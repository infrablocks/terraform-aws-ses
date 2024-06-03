variable "domain" {
  type = string
}

variable "zone_id" {
  type    = string
  default = ""
}

variable "verify_domain" {
  type    = bool
  default = false
}

variable "verify_dkim" {
  type    = bool
  default = false
}

variable "create_spf_record" {
  type    = bool
  default = false
}

variable "mail_from_domain" {
  type     = string
  default  = null
  nullable = true

  validation {
    condition     = var.mail_from_domain != null ? can(regex("^[a-zA-Z0-9-]+$", var.mail_from_domain)) : true
    error_message = "The mail_from_domain must be subdomain of the primary domain."
  }
}

variable "ses_group_enabled" {
  type    = bool
  default = true
}

variable "ses_group_name" {
  type = string
}

variable "ses_group_path" {
  type    = string
  default = "/"
}

variable "ses_user_enabled" {
  type    = bool
  default = true
}

variable "ses_user_public_gpg_key_path" {
  type = string
}