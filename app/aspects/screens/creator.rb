# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Saves Base64 encoded content as image.
      class Creator
        include Dry::Monads[:result]
        include Deps[
          "aspects.screens.creators.encoded",
          "aspects.screens.creators.html",
          "aspects.screens.creators.preprocessed",
          "aspects.screens.creators.unprocessed",
          model_repository: "repositories.model"
        ]
        include Initable[payload: Creators::Payload]

        def call **parameters
          id = parameters.delete :model_id
          model = model_repository.find id

          return Failure "Unable to find model for ID: #{id.inspect}." unless model

          handle model, parameters
        end

        private

        def handle model, parameters
          case parameters
            in label:, name:, content: then handle_html model:, label:, name:, content:
            in label:, name:, uri:, preprocessed: true
              handle_preprocessed model:, label:, name:, content: uri
            in label:, name:, uri: then handle_unprocessed model:, label:, name:, content: uri
            in label:, name:, data: then handle_encoded_data model:, label:, name:, content: data
            else Failure "Invalid parameters: #{parameters.inspect}."
          end
        end

        def handle_html(**) = html.call payload[**]

        def handle_unprocessed(**) = unprocessed.call payload[**]

        def handle_preprocessed(**) = preprocessed.call payload[**]

        def handle_encoded_data(**) = encoded.call payload[**]
      end
    end
  end
end
