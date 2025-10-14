# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Extensions
      # The new action.
      class New < Terminus::Action
        include Deps[:htmx]

        DEFAULTS = {
          tags: [],
          mode: "light",
          kind: "poll",
          verb: "get",
          start_at: "2025-01-01T00:00:00",
          days: [],
          interval: 1,
          template: <<~BODY
            <div class="screen screen--{{model.bit_depth}}bit screen--{{model.name}} screen--lg screen--{{model.orientation}} screen--1x">
              <div class="view view--full">
              </div>
            </div>
          BODY
        }.freeze

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
