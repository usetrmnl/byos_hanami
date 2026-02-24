# frozen_string_literal: true

require "dry/core"
require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render static data.
        class Static
          include Deps[renderer: "liquid.default"]
          include Initable[capsule: Aspects::Extensions::Capsule]
          include Dry::Monads[:result]

          def call extension, context: Dry::Core::EMPTY_HASH
            content = renderer.call extension.template, context.merge("source" => extension.body)
            Success capsule[content:]
          end
        end
      end
    end
  end
end
