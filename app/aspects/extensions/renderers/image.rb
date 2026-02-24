# frozen_string_literal: true

require "dry/core"
require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render image data.
        class Image
          include Deps[renderer: "liquid.default"]
          include Initable[capsule: Aspects::Extensions::Capsule]
          include Dry::Monads[:result]

          def call extension, context: Dry::Core::EMPTY_HASH
            uris = extension.uris

            if uris.one?
              content = renderer.call(
                extension.template,
                {**context, "source" => {"url" => uris.first}}
              )

              Success capsule[content:]
            else
              render_many extension, context
            end
          end

          private

          def render_many extension, context
            data = extension.uris.each.with_index(1).with_object({}) do |(uri, index), all|
              all["source_#{index}"] = {"url" => uri}
            end

            Success capsule[content: renderer.call(extension.template, context.merge(data))]
          end
        end
      end
    end
  end
end
