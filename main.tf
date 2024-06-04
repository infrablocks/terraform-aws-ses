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
