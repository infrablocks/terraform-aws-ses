data "aws_iam_policy_document" "allow_cross_account_lambda_send_email_statement" {
  statement {
    sid = "CrossAccountLambdaSendEmailPermission"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.ses_domain.arn]

    condition {
      test   = "StringLike"
      values = [
        for account_id in var.allowed_cross_account_lambda_send_email_account_ids :
        "arn:aws:lambda:${var.region}:${account_id}:function:*"
      ]
      variable = "aws:sourceARN"
    }
  }
}

resource "aws_ses_identity_policy" "identity_policy" {
  count = var.allow_cross_account_lambda_send_email ? 1 : 0

  identity = aws_ses_domain_identity.ses_domain.arn
  name     = "ses-identity-policy"
  policy   = data.aws_iam_policy_document.allow_cross_account_lambda_send_email_statement.json
}