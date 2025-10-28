# frozen_string_literal: true

require "dry/monads"
require "refinements/hash"

module Terminus
  module Aspects
    module Extensions
      # Renders extension based on kind.
      class Renderer
        include Deps[
          "aspects.extensions.renderers.image",
          "aspects.extensions.renderers.poll",
          "aspects.extensions.renderers.static",
          model_repository: "repositories.model"
        ]
        include Dry::Monads[:result]

        using Refinements::Hash

        def call(extension, model_id) = process extension, build_context(extension, model_id)

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

        def build_context extension, model_id
          model = model_repository.find model_id
          {"extension" => extension.data, "model" => model.liquid_attributes.stringify_keys!}
        end
      end
    end
  end
end
