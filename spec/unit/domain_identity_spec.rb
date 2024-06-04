# frozen_string_literal: true

require 'spec_helper'

describe 'SES' do
  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
          vars.verify_domain = false
          vars.create_spf_record = false
          vars.verify_dkim = false
      end
    end

    it 'creates an domain identity' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_identity')
              .once)
    end
  end
end
