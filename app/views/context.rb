# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    # The application custom view context.
    class Context < Hanami::View::Context
      include Deps[:htmx]

      def htmx? = htmx.request? request.env, :request, "true"
    end
  end
end
