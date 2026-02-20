# frozen_string_literal: true

require "dry/core"
require "initable"
require "refinements/hash"

module Terminus
  module Aspects
    module Firmware
      module Headers
        # Transforms sensors header into an array of records.
        class SensorsTransformer
          include Initable[source: "device", delimiters: {line: ",", attribute: ";", pair: "="}]

          using Refinements::Hash

          def call content
            content = String content

            return Dry::Core::EMPTY_ARRAY unless content.include? pair_delimiter

            content.split(line_delimiter).map { transform it }
          end

          private

          def line_delimiter = delimiters.fetch :line

          def attribute_delimiter = delimiters.fetch :attribute

          def pair_delimiter = delimiters.fetch :pair

          def transform line
            line.split(attribute_delimiter)
                .to_h { it.split pair_delimiter }
                .merge!(source:)
                .symbolize_keys!
                .transform_value!(:created_at) { Time.at it.to_i }
          end
        end
      end
    end
  end
end
