data "aws_iam_policy_document" "allow_cross_account_iam_send_email_statement" {
  statement {
    sid = "CrossAccountIamSendEmailPermission"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        for account_id in var.allowed_cross_account_iam_send_email_account_ids :
        "${account_id}"
      ]
    }

    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.ses_domain.arn]

    condition {
      test   = "ArnLike"
      values = [
        for account_id in var.allowed_cross_account_iam_send_email_account_ids :
        "arn:aws:iam::${account_id}:role/*"
      ]
      variable = "aws:PrincipalArn"
    }
  }
}

resource "aws_ses_identity_policy" "identity_policy" {
  count = var.allow_cross_account_iam_send_email ? 1 : 0

  identity = aws_ses_domain_identity.ses_domain.arn
  name     = "ses-identity-policy"
  policy   = data.aws_iam_policy_document.allow_cross_account_iam_send_email_statement.json
}