# frozen_string_literal: true

module Terminus
  module API
    # Provides API client configuration with safe defaults.
    Configuration = Data.define :api_uri, :headers do
      def initialize api_uri: "https://trmnl.app/api", headers: {accept: "application/json"}
        super
      end
    end
  end
end
