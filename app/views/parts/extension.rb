# frozen_string_literal: true

require "dry/core"
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

        def formatted_fields = format_as_json :fields

        def formatted_headers = format_as_json :headers

        def formatted_poll_body = format_as_json :poll_body

        def formatted_repeat_days = repeat_days ? repeat_days.join(",") : ""

        def formatted_static_body = format_as_json :static_body

        def formatted_uris = uris.join "\n"

        private

        def format_as_json method
          content = Hash public_send method
          content.empty? ? Dry::Core::EMPTY_STRING : content.to_json
        end
      end
    end
  end
end
