output "ses_domain_identity_arn" {
  value = try(aws_ses_domain_identity.ses_domain[0].arn, "")
}

output "ses_domain_identity_verification_token" {
  value = try(aws_ses_domain_identity.ses_domain[0].verification_token, "")
}

output "ses_dkim_tokens" {
  value = try(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, "")
}

output "spf_record" {
  value = try(aws_route53_record.amazonses_spf_record[0].fqdn, "")
}

output "custom_from_domain" {
  value = try(aws_ses_domain_mail_from.custom_mail_from[*].mail_from_domain, "")
}

output "ses_group_name" {
  value = var.ses_group_name
}

output "ses_user" {
  value = module.ses_user
}
