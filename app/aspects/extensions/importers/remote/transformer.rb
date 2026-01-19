# frozen_string_literal: true

require "dry/monads"
require "refinements/string"

module Terminus
  module Aspects
    module Extensions
      module Importers
        module Remote
          # Transforms remote plugin (recipe) data into extension attributes.
          class Transformer
            include Deps[
              "aspects.extensions.importers.remote.extractor",
              "aspects.extensions.importers.remote.transformers.keys",
              "aspects.extensions.importers.remote.transformers.kind",
              "aspects.extensions.importers.remote.transformers.template",
              "aspects.extensions.importers.remote.transformers.default",
              repository: "repositories.extension"
            ]

            include Dry::Monads[:result]

            using Refinements::String

            def initialize(schema: Importers::Remote::Schema, **)
              @schema = schema
              super(**)
            end

            def call(id) = extractor.call(id).bind { |content| extract content }

            private

            attr_reader :schema

            def extract content
              # Order is important.
              validate(content).bind { |attributes| keys.call attributes.to_h }
                               .bind { |attributes| kind.call attributes }
                               .bind { |attributes| template.call attributes, content[:full].dup }
                               .bind { |attributes| default.call attributes }
            end

            def validate content
              YAML.load(content[:settings])
                  .then { |settings| schema.call settings }
                  .to_monad
            end
          end
        end
      end
    end
  end
end
