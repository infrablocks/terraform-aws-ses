# frozen_string_literal: true

require 'aws-sdk'
require 'awspec'

module Awspec
  module Helper
    module Finder
      def ses_v2_client
        @ses_v2_client ||= Aws::SES
        Awspec::Helper::ClientWrap.new(
          Aws::SESV2::Client.new(CLIENT_OPTIONS)
        )
      end
    end
  end
end
