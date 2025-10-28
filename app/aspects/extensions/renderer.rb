# frozen_string_literal: true

require "dry/core"
require "dry/monads"
require "initable"
require "liquid"

module Terminus
  module Aspects
    module Extensions
      # Renders extension based on kind.
      class Renderer
        include Deps[
          "aspects.extensions.renderers.image",
          "aspects.extensions.renderers.poll",
          "aspects.extensions.renderers.static"
        ]
        include Dry::Monads[:result]
        include Initable[parser: Liquid::Template]

        def call extension
          kind = extension.kind

          case kind
            when "image" then image.call extension
            when "poll" then poll.call extension
            when "static" then static.call extension
            else Failure "Unsupported extension kind: #{kind}."
          end
        end
      end
    end
  end
end
