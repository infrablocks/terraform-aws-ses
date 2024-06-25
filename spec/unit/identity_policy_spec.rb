# frozen_string_literal: true

require 'spec_helper'

describe 'identity policy' do
  let(:region) do
    var(role: :root, name: 'region')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create an identity policy' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_ses_identity_policy'))
    end
  end

  describe 'when allow_cross_account_iam_send_email is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.allow_cross_account_iam_send_email = true
        vars.allowed_cross_account_iam_send_email_account_ids = %w[
          176145454894
          879281328474
        ]
      end
    end

    it 'creates an identity policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_identity_policy')
              .once)
    end

    # it 'allows the iam service to send emails from other accounts' do
    #   expect(@plan)
    #     .to(include_resource_creation(type: 'aws_ses_identity_policy')
    #           .with_attribute_value(
    #             :policy,
    #             a_policy_with_statement(
    #               Sid: 'CrossAccountIamSendEmailPermission',
    #               Effect: 'Allow',
    #               Action: %w[
    #                 SES:SendEmail
    #                 SES:SendRawEmail
    #               ],
    #               Condition: a_hash_including(
    #                 StringLike: a_hash_including(
    #                   'aws:principalarn': contain_exactly(
    #                         ...
    #                   )
    #                 )
    #               )
    #             )
    #           ))
    # end
  end
end
