# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render image data.
        class Image
          include Deps[renderer: "liquid.default"]
          include Dry::Monads[:result]

          def call extension
            Success extension.uris.one? ? render_single(extension) : render_multiple(extension)
          end

          private

          def render_single extension
            renderer.call extension.template, {"url" => extension.uris.first}
          end

          def render_multiple extension
            data = extension.uris.each.with_index(1).with_object({}) do |(uri, index), all|
              all["source_#{index}"] = {"url" => uri}
            end

            renderer.call extension.template, data
          end
        end
      end
    end
  end
end
