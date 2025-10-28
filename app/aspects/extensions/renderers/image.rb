# frozen_string_literal: true

require "dry/core"
require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render image data.
        class Image
          include Deps[renderer: "liquid.default"]
          include Dry::Monads[:result]

          def call extension, context: Dry::Core::EMPTY_HASH
            uris = extension.uris

            if uris.one?
              Success renderer.call(extension.template, {**context, "url" => uris.first})
            else
              render_multiple extension, context
            end
          end

          private

          def render_multiple extension, context
            data = extension.uris.each.with_index(1).with_object({}) do |(uri, index), all|
              all["source_#{index}"] = {"url" => uri}
            end

            Success renderer.call(extension.template, context.merge(data))
          end
        end
      end
    end
  end
end
