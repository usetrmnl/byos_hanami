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
          repeat_days: [],
          repeat_interval: 1,
          template: <<~BODY
            <div class="screen screen--2bit screen--v2 screen--lg screen--landscape screen--1x">
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
