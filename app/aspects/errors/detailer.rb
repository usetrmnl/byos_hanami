# frozen_string_literal: true

require "refinements/array"
require "refinements/hash"

module Terminus
  module Aspects
    module Errors
      # Formats Dry Schema result, hash, or string as a single sentence.
      class Detailer
        using Refinements::Array
        using Refinements::Hash

        def initialize delimiter: "."
          @delimiter = delimiter
        end

        def call object, prefix = nil
          case object
            when Dry::Schema::Result
              "#{prefix}#{build_messages(object.errors.to_h).to_sentence}."
            when Hash
              "#{prefix}#{build_messages(object).to_sentence}."
            else
              "#{prefix}#{object}"
          end
        end

        private

        attr_reader :delimiter

        def build_messages collection
          collection.each.with_object [] do |(key, value), all|
            if value.is_a? Hash
              flatten key, value, all
            else
              all.append "#{key} #{value.to_sentence}"
            end
          end
        end

        def flatten key, value, collection
          value.flatten_keys!(delimiter:).each do |sub_key, sub_value|
            collection.append "#{key}#{delimiter}#{sub_key} #{sub_value.to_sentence}"
          end
        end
      end
    end
  end
end
