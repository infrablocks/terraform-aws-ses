output "ses_domain_identity_arn" {
  value = try(module.ses.ses_domain_identity_arn, "")
}

output "ses_domain_identity_verification_token" {
  value = try(module.ses.ses_domain_identity_verification_token, "")
}

output "ses_dkim_tokens" {
  value = try(module.ses.ses_dkim_tokens, "")
}

output "spf_record" {
  value = try(module.ses.spf_record, "")
}

output "mail_from_domain" {
  value = try(module.ses.mail_from_domain, "")
}
