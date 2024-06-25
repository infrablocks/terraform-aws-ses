variable "region" {}

variable "domain" {
  default = null
}

variable "zone_id" {
  default = null
}

variable "verify_domain" {
  type    = bool
  default = null
}

variable "verify_dkim" {
  type    = bool
  default = null
}

variable "create_spf_record" {
  type    = bool
  default = null
}

variable "use_custom_mail_from_domain" {
  type    = bool
  default = null
}

variable "mail_from_domain" {
  default = null
}

variable "allow_cross_account_iam_send_email" {
  type    = bool
  default = null
}

variable "allowed_cross_account_iam_send_email_account_ids" {
  type    = list(string)
  default = null
}
