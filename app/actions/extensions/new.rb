# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Extensions
      # The new action.
      class New < Terminus::Action
        include Deps[:htmx]

        DEFAULTS = {repeat_interval: 1, padding: false, last_day_of_month: false}.freeze

        def initialize(defaults: DEFAULTS, **)
          @defaults = defaults
          super(**)
        end

        def handle request, response
          view_settings = {fields: defaults}
          view_settings[:layout] = false if htmx.request? request.env, :request, "true"

          response.render view, **view_settings
        end

        private

        attr_reader :defaults
      end
    end
  end
end
