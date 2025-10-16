# frozen_string_literal: true

require "dry/monads"
require "initable"
require "liquid"

module Terminus
  module Aspects
    module Extensions
      module Renderers
        # Uses Liquid template to render remote data.
        class Poll
          include Deps[fetcher: "aspects.extensions.multi_fetcher"]
          include Initable[parser: Liquid::Template]
          include Dry::Monads[:result]

          def self.reduce collection
            collection.each do |key, value|
              collection[key] = value.success? ? value.success : value.failure
            end
          end

          def call extension
            fetcher.call(extension)
                   .fmap { |collection| self.class.reduce collection }
                   .fmap { |data| data.one? ? data["0"] : data }
                   .fmap { |data| render extension.template, data }
          end

          private

          def render(template, data) = parser.parse(template).render data
        end
      end
    end
  end
end
