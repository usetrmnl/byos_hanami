# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    # The application custom view context.
    class Context < Hanami::View::Context
      include Deps[:htmx]

      HTMX_CONFIGURATION = {"allowScriptTags" => false, "defaultSwapStyle" => "outerHTML"}.freeze

      def htmx? = htmx.request? request.env, :request, "true"

      def htmx_configuration default: HTMX_CONFIGURATION
        content_for(:htmx_merge).then { it ? default.merge(it) : default }
                                .to_json
      end
    end
  end
end
