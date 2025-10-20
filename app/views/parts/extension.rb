# frozen_string_literal: true

require "dry/core"
require "hanami/view"
require "json"

module Terminus
  module Views
    module Parts
      # The extension presenter.
      class Extension < Hanami::View::Part
        def alpine_tags
          Array(tags).map { %('#{it}') }
                     .join(",")
                     .then { "[#{it}]" }
        end

        def formatted_body = format_as_json :body

        def formatted_fields = format_as_json :fields

        def formatted_headers = format_as_json :headers

        def formatted_repeat_days = repeat_days ? repeat_days.join(",") : ""

        def formatted_uris = uris.join "\n"

        private

        def format_as_json method
          content = Hash public_send method

          return Dry::Core::EMPTY_STRING if content.empty?

          JSON content, indent: "  ", space: " ", object_nl: "\n", array_nl: "\n"
        end
      end
    end
  end
end
