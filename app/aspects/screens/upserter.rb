# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates or updates a screen.
      class Upserter
        include Deps[
          "aspects.screens.upserters.encoded",
          "aspects.screens.upserters.html",
          "aspects.screens.upserters.preprocessed",
          "aspects.screens.upserters.unprocessed",
          model_repository: "repositories.model"
        ]
        include Initable[mold: Mold]
        include Dry::Monads[:result]

        def call **parameters
          parameters.delete(:model_id)
                    .then { |id| find_model id }
                    .bind { |model| handle model, parameters }
        end

        private

        def find_model id
          model = model_repository.find id

          return Success model if model

          Failure "Unable to find model for ID: #{id.inspect}."
        end

        def handle model, parameters
          case parameters
            in label:, name:, content: then handle_html model, label:, name:, content:
            in label:, name:, uri:, preprocessed: true
              handle_preprocessed model, label:, name:, content: uri
            in label:, name:, uri: then handle_unprocessed model, label:, name:, content: uri
            in label:, name:, data: then handle_encoded_data model, label:, name:, content: data
            else Failure "Invalid parameters: #{parameters.inspect}."
          end
        end

        def handle_html(*, **) = html.call mold.for(*, **)

        def handle_unprocessed(*, **) = unprocessed.call mold.for(*, **)

        def handle_preprocessed(*, **) = preprocessed.call mold.for(*, **)

        def handle_encoded_data(*, **) = encoded.call mold.for(*, **)
      end
    end
  end
end
