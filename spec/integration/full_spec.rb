# frozen_string_literal: true

require 'spec_helper'

describe 'full example' do
  let(:domain) do
    var(role: :full, name: 'domain')
  end
  let(:zone_id) do
    var(role: :full, name: 'zone_id')
  end
  let(:mail_from_domain) do
    var(role: :full, name: 'mail_from_domain')
  end

  let(:domain_identity_arn) do
    output(role: :full, name: 'ses_domain_identity_arn')
  end
  let(:domain_identity_verification_token) do
    output(role: :full, name: 'ses_domain_identity_verification_token')
  end
  let(:dkim_tokens) do
    output(role: :full, name: 'ses_dkim_tokens')
  end
  let(:spf_record) do
    output(role: :full, name: 'spf_record')
  end
  let(:output_mail_from_domain) do
    output(role: :full, name: 'mail_from_domain')
  end

  # let(:hosted_zone) do
  #   route53_hosted_zone(zone_id)
  # end

  let(:domain_identity) do
    ses_v2_client.get_email_identity(email_identity: domain)
  rescue Aws::SESV2::Errors::NotFoundException
    nil
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'Domain identity' do
    it 'creates an email identity' do
      expect(domain_identity).not_to(be_nil)
    end

    it 'is of type domain' do
      expect(domain_identity.identity_type).to(eq('DOMAIN'))
    end

    it 'outputs the domain identity ARN' do
      expect(domain_identity_arn).not_to(be_nil)
    end

    it 'outputs the domain identity verification token' do
      expect(domain_identity_verification_token).not_to(be_nil)
    end

    it 'outputs the dkim tokens' do
      expect(dkim_tokens).to(eq(domain_identity.dkim_attributes.tokens))
    end

    it 'outputs the mail from domain' do
      expect(output_mail_from_domain).to(eq(["#{mail_from_domain}.#{domain}"]))
    end

    it 'outputs the spf record' do
      expect(spf_record).to(eq("#{mail_from_domain}.#{domain}"))
    end

    # it 'includes the component and deployment identifier as tags' do
    #   expect(domain_identity.tags)
    #     .to(include(
    #           {
    #             'Component' => component,
    #             'DeploymentIdentifier' => deployment_identifier
    #           }
    #         ))
    # end
  end
end
