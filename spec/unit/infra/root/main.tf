data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "ses" {
  source = "../../../.."

  domain = var.domain

  zone_id = var.zone_id

  verify_domain = var.verify_domain

  verify_dkim = var.verify_dkim

  create_spf_record = var.create_spf_record

  mail_from_domain = var.mail_from_domain

  providers = {
    aws = aws
  }
}
