# frozen_string_literal: true

require "dry/monads"
require "initable"
require "liquid"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render image data.
        class Image
          include Initable[parser: Liquid::Template]
          include Dry::Monads[:result]

          def call extension
            Success extension.uris.one? ? render_single(extension) : render_multiple(extension)
          end

          private

          def render_single extension
            parser.parse(extension.template).render({"url" => extension.uris.first})
          end

          def render_multiple extension
            data = extension.uris.each.with_index(0).with_object({}) do |(uri, index), all|
              all[index.to_s] = {"url" => uri}
            end

            parser.parse(extension.template).render(data)
          end
        end
      end
    end
  end
end
