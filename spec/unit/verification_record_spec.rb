# frozen_string_literal: true

require 'spec_helper'

describe 'verification record' do
  let(:zone_id) do
    var(role: :root, name: 'zone_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create a verification record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end
  end

  describe 'when verify domain is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.verify_domain = true
      end
    end

    it 'creates a verification record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'has expected zone id' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, zone_id))
    end
  end
end
