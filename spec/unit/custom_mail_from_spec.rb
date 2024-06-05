# frozen_string_literal: true

require 'spec_helper'

describe 'domain mail from' do
  let(:domain) do
    var(role: :root, name: 'domain')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create a domain mail from' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_ses_domain_mail_from')
              .once)
    end
  end

  describe 'when mail from domain is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.mail_from_domain = 'custom'
      end
    end

    it 'creates a domain mail from' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_mail_from')
                  .once)
    end

    it 'includes the behaviour on mx failure' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_mail_from')
              .with_attribute_value(:behavior_on_mx_failure, 'UseDefaultValue'))
    end
  end
end
