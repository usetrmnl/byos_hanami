# frozen_string_literal: true

require "dry/core"
require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render remote data.
        class Poll
          include Deps[fetcher: "aspects.extensions.multi_fetcher", renderer: "liquid.default"]
          include Dry::Monads[:result]

          def self.reduce collection
            collection.each do |key, value|
              collection[key] = value.success? ? value.success : value.failure
            end
          end

          def call extension, context: Dry::Core::EMPTY_HASH
            fetcher.call(extension)
                   .fmap { |collection| self.class.reduce collection }
                   .fmap { |data| data.one? ? data["source_1"] : data }
                   .fmap { |data| render extension.template, context, data }
          end

          private

          def render(template, context, data) = renderer.call template, context.merge(data)
        end
      end
    end
  end
end
