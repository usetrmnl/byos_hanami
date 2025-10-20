# frozen_string_literal: true

require "dry/core"
require "hanami/view"
require "initable"

module Terminus
  module Views
    module Parts
      # The extension presenter.
      class Extension < Hanami::View::Part
        include Initable[json_formatter: Aspects::JSONFormatter]

        def alpine_tags
          Array(tags).map { %('#{it}') }
                     .join(",")
                     .then { "[#{it}]" }
        end

        def formatted_body = format_as_json :body

        def formatted_data = format_as_json :data

        def formatted_days = days ? days.join(",") : ""

        def formatted_fields = format_as_json :fields

        def formatted_headers = format_as_json :headers

        def formatted_uris = uris.join "\n"

        def formatted_start_at
          start_at ? start_at.strftime("%Y-%m-%dT%H:%M:%S") : "2025-01-01T00:00:00"
        end

        private

        def format_as_json method
          content = Hash public_send method

          content.empty? ? Dry::Core::EMPTY_STRING : json_formatter.call(content)
        end
      end
    end
  end
end
