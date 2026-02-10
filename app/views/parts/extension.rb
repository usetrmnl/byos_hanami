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

        def formatted_body = json_formatter.call body

        def formatted_data = json_formatter.call data

        def formatted_days = days ? days.join(",") : ""

        def formatted_fields = json_formatter.call fields

        def formatted_headers = json_formatter.call headers

        def formatted_uris = uris.join "\n"

        def formatted_start_at
          start_at ? start_at.strftime("%Y-%m-%dT%H:%M:%S") : "2025-01-01T00:00:00"
        end
      end
    end
  end
end
