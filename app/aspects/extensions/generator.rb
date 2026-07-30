# frozen_string_literal: true

require "dry/monads"
require "refinements/hash"

module Terminus
  module Aspects
    module Extensions
      # Generates specific kind of extension.
      class Generator
        include Deps[
          "aspects.extensions.contextualizer",
          "aspects.extensions.generators.image",
          "aspects.extensions.generators.poll",
          "aspects.extensions.generators.static"
        ]
        include Dry::Monads[:result]

        using Refinements::Hash

        def call extension, model_id: nil, device_id: nil
          process extension, contextualizer.call(extension, model_id:, device_id:)
        end

        private

        def process extension, context
          kind = extension.kind

          case kind
            when "image" then image.call extension, context:
            when "poll" then poll.call extension, context:
            when "static" then static.call extension, context:
            else Failure "Unsupported extension kind: #{kind}."
          end
        end
      end
    end
  end
end
