# frozen_string_literal: true

require "hanami/view"

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

        def fields_field = fields ? fields.to_json : "{}"

        def formatted_uris = uris.join "\n"

        def headers_field = headers ? headers.to_json : "{}"

        def poll_body_field = poll_body ? poll_body.to_json : "{}"

        def repeat_days_field = repeat_days ? repeat_days.join(",") : ""

        def static_body_field = static_body ? static_body.to_json : "{}"
      end
    end
  end
end
