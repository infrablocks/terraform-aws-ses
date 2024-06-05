# frozen_string_literal: true

require 'spec_helper'

describe 'dkim record' do
  let(:zone_id) do
    var(role: :root, name: 'zone_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create a dkim record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record'))
    end
  end

  describe 'when verify dkim is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.verify_dkim = true
      end
    end

    it 'creates 3 dkim records' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .thrice)
    end

    it 'has expected zone id' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, zone_id)
              .thrice)
    end

    it 'has expected type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'CNAME')
              .thrice)
    end

    it 'has expected ttl' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:ttl, 1800)
              .thrice)
    end

    it 'outputs the dkim tokens' do
      expect(@plan)
        .to(include_output_creation(
              name: 'ses_dkim_tokens'
            ))
    end
  end
end
