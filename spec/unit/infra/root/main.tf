data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "ses" {
  source = "../../../.."

  region = var.region

  domain = var.domain

  zone_id = var.zone_id

  verify_domain = var.verify_domain

  verify_dkim = var.verify_dkim

  create_spf_record = var.create_spf_record

  use_custom_mail_from_domain = var.use_custom_mail_from_domain

  mail_from_domain = var.mail_from_domain

  allow_cross_account_iam_send_email = var.allow_cross_account_iam_send_email

  allowed_cross_account_iam_send_email_account_ids = var.allowed_cross_account_iam_send_email_account_ids

  providers = {
    aws = aws
  }
}
