# frozen_string_literal: true

require 'spec_helper'

describe 'domain identity' do
  let(:domain) do
    var(role: :root, name: 'domain')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a domain identity' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_identity')
              .once)
    end

    it 'includes the domain' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_identity')
              .with_attribute_value(:domain, domain))
    end
  end
end
