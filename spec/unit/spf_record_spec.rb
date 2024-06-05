# frozen_string_literal: true

require 'spec_helper'

describe 'spf record' do
  let(:zone_id) do
    var(role: :root, name: 'zone_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'does not create a spf record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .once)
    end
  end

  describe 'when create spf record is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.create_spf_record = true
      end
    end

    it 'creates a spf record' do
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
              .with_attribute_value(:type, 'TXT'))
    end

    it 'has expected ttl' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:ttl, 3600))
    end

    it 'has expected records' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:records,
                                    ['v=spf1 include:amazonses.com -all']))
    end

    it 'outputs the spf record' do
      expect(@plan)
        .to(include_output_creation(
              name: 'spf_record'
            ))
    end
  end
end
