# frozen_string_literal: true

require "dry/monads"
require "initable"
require "liquid"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render static data.
        class Static
          include Initable[parser: Liquid::Template]
          include Dry::Monads[:result]

          def call extension
            Success parser.parse(extension.template).render(extension.body)
          end
        end
      end
    end
  end
end
