# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates or updates a screen.
      class Upserter
        include Deps[
          "aspects.models.finder",
          "aspects.screens.upserters.encoded",
          "aspects.screens.upserters.html",
          "aspects.screens.upserters.preprocessed",
          "aspects.screens.upserters.unprocessed"
        ]
        include Initable[mold: Mold]
        include Dry::Monads[:result]

        def call **parameters
          model_id = parameters.delete :model_id
          device_id = parameters.delete :device_id

          finder.call(model_id:, device_id:).bind { |model| handle model, parameters }
        end

        private

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
