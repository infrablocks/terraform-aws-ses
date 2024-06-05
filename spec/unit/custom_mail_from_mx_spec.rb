# frozen_string_literal: true

require 'spec_helper'

describe 'custom mail from mx' do
  let(:zone_id) do
    var(role: :root, name: 'zone_id')
  end

  let(:region) do
    var(role: :root, name: 'region')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create a custom mail from mx' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when mail from domain is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.use_custom_mail_from_domain = true
      end
    end

    it 'creates a custom mail from mx' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'has expected zone id' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, zone_id))
    end

    it 'has expected type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, 'MX'))
    end

    it 'has expected ttl' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:ttl, 600))
    end

    it 'has expected records' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(
                :records, ["10 feedback-smtp.#{region}.amazonses.com"]
              ))
    end
  end
end
