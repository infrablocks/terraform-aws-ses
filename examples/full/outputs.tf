output "ses_domain_identity_arn" {
  value = module.ses.ses_domain_identity_arn
}

output "ses_domain_identity_verification_token" {
  value = module.ses.ses_domain_identity_verification_token
}

output "ses_dkim_tokens" {
  value = module.ses.ses_dkim_tokens
}

output "spf_record" {
  value = module.ses.spf_record
}

output "mail_from_domain" {
  value = module.ses.mail_from_domain
}
