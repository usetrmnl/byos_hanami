# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render static data.
        class Static
          include Deps[renderer: "liquid.default"]
          include Dry::Monads[:result]

          def call extension
            Success renderer.call(extension.template, extension.body)
          end
        end
      end
    end
  end
end
