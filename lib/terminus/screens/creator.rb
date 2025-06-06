# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Screens
    # Saves Base64 encoded content as image.
    class Creator
      include Dry::Monads[:result]
      include Savers::Dependencies[:encoded, :html, :preprocessed_uri, :unprocessed_uri]

      def call output_path, **parameters
        case parameters
          in content: then html.call content, output_path
          in uri:, dimensions: then unprocessed_uri.call uri, output_path, dimensions
          in uri:, preprocessed: true then preprocessed_uri.call uri, output_path
          in data:, dimensions: then encoded.call data, output_path, dimensions
          else Failure "Invalid parameters: #{parameters.inspect}."
        end
      end
    end
  end
end
