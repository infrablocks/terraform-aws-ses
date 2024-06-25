variable "region" {
  type        = string
  description = "The region of the deployment (including any allowed account ids)."
}

variable "domain" {
  type        = string
  description = "The domain to create the SES identity for."
}

variable "zone_id" {
  type        = string
  description = "Route53 parent zone ID."
  default     = ""
}

variable "verify_domain" {
  type        = bool
  description = "If true the module will create Route53 DNS records used for domain verification."
  default     = false
  nullable    = false
}

variable "verify_dkim" {
  type        = bool
  description = "If true the module will create Route53 DNS records used for DKIM verification."
  default     = false
  nullable    = false
}

variable "create_spf_record" {
  type        = bool
  description = "If true the module will create an SPF record for `domain`."
  default     = false
  nullable    = false
}

variable "use_custom_mail_from_domain" {
  type        = bool
  description = "If true the module will create a custom subdomain for the `MAIL FROM` address."
  default     = false
  nullable    = false
}

variable "mail_from_domain" {
  type        = string
  description = "If provided the module will create a custom subdomain for the `MAIL FROM` address."
  default     = null
  nullable    = true

  validation {
    condition     = var.mail_from_domain != null ? can(regex("^[a-zA-Z0-9-]+$", var.mail_from_domain)) : true
    error_message = "If provided must be a valid subdomain."
  }
}

variable "allow_cross_account_iam_send_email" {
  type        = bool
  description = "If true allows iam roles to send emails from the account ids provided in `allowed_cross_account_iam_send_email_account_ids`."
  default     = false
  nullable    = false
}

variable "allowed_cross_account_iam_send_email_account_ids" {
  type        = list(string)
  description = "Account ids for cross account iam roles to allowing sending emails from."
  default     = []
  nullable    = false
}
