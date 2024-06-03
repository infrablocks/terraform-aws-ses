locals {
  mail_from_domain_enabled = var.mail_from_domain != null
}

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}

resource "aws_route53_record" "aws_ses_verification_record" {
  count = var.verify_domain ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "1800"
  records = [aws_ses_domain_identity.ses_domain[*].verification_token]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = aws_ses_domain_identity.ses_domain[*].domain
}

resource "aws_route53_record" "aws_ses_dkim_record" {
  count = var.verify_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim[0].dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim[0].dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "aws_ses_spf_record" {
  count = var.create_spf_record ? 1 : 0

  zone_id = var.zone_id
  name    = local.mail_from_domain_enabled ? aws_ses_domain_mail_from.custom_mail_from[*].mail_from_domain : aws_ses_domain_identity.ses_domain[*].domain
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_domain_mail_from" "custom_mail_from" {
  count                  = local.mail_from_domain_enabled ? 1 : 0
  domain                 = aws_ses_domain_identity.ses_domain[*].domain
  mail_from_domain       = "${var.mail_from_domain}.${aws_ses_domain_identity.ses_domain[*].domain}"
  behavior_on_mx_failure = "UseDefaultValue"
}

data "aws_region" "current" {
  count = local.mail_from_domain_enabled ? 1 : 0
}

resource "aws_route53_record" "custom_mail_from_mx" {
  count = local.mail_from_domain_enabled ? 1 : 0

  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.custom_mail_from[*].mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current[*].name}.amazonses.com"]
}


data "aws_iam_policy_document" "ses_policy" {
  count = var.ses_user_enabled ? 1 : 0

  statement {
    actions   = ["ses:SendRawEmail"]
    resources = aws_ses_domain_identity.ses_domain[*].arn
  }
}

resource "aws_iam_group" "ses_users" {
  count = var.ses_user_enabled ? 1 : 0

  name = var.ses_group_name
  path = var.ses_group_path
}

resource "aws_iam_group_policy" "ses_group_policy" {
  count = var.ses_user_enabled ? 1 : 0

  name  = var.ses_group_name
  group = aws_iam_group.ses_users[0].name

  policy = data.aws_iam_policy_document.ses_policy[*].json
}

module "ses_user" {
  source  = "infrablocks/user/aws"
  version = "1.1.0-rc.7"

  user_name = "ses_email_sender"
  enforce_mfa = "no"
  include_access_key = "yes"
  include_login_profile = "no"
  user_public_gpg_key = filebase64(var.ses_user_public_gpg_key_path)
}

resource "aws_iam_user_group_membership" "ses_user" {
  count = var.ses_user_enabled ? 1 : 0

  user = module.ses_user.user_name

  groups = [
    aws_iam_group.ses_users[0].name
  ]
}

