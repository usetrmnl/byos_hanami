# frozen_string_literal: true

require "htmx"
require "refinements/hash"

module Terminus
  module Views
    # The view helpers.
    module Helpers
      extend Hanami::View::Helpers::TagHelper

      using Refinements::Hash

      module_function

      def field_for key, attributes, record = nil
        return attributes[key] unless record

        attributes.fetch_value key, record.public_send(key)
      end

      def human_at(at) = (at.strftime "%B %d %Y at %H:%M %Z" if at)

      def size bytes, megabyte: 1_048_576.0
        case bytes
          when ...megabyte then "#{bytes} B"
          else (bytes / megabyte).then { |megabytes| format("%.2f MB", megabytes).sub(".00", "") }
        end
      end
    end
  end
end
