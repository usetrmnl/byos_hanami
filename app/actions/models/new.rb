# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Models
      # The new action.
      class New < Terminus::Action
        include Deps[:htmx]

        DEFAULTS = {
          description: nil,
          mime_type: "image/png",
          colors: 2,
          bit_depth: 1,
          rotation: 0,
          offset_x: 0,
          offset_y: 0,
          scale_factor: 1,
          width: 800,
          height: 480,
          published_at: nil
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
