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
    end
  end
end
