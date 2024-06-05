module "ses" {
  source = "../../../.."

  domain = var.domain

  zone_id = var.zone_id

  verify_domain = true

  verify_dkim = true

  create_spf_record = true

  use_custom_mail_from_domain = true

  mail_from_domain = var.mail_from_domain

  providers = {
    aws = aws
  }
}
