# frozen_string_literal: true

require 'spec_helper'

describe 'dkim record' do
  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a domain dkim' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_ses_domain_dkim')
              .once)
    end
  end
end
