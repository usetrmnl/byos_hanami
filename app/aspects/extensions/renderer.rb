# frozen_string_literal: true

require "initable"
require "liquid"

module Terminus
  module Aspects
    module Extensions
      # Processes and renders Liquid template.
      class Renderer
        include Deps[view: "views.extensions.dynamic"]
        include Initable[parser: Liquid::Template]

        def call extension, data
          template = parser.parse extension.template_full
          body = template.render data
          view.call body:
        end
      end
    end
  end
end
