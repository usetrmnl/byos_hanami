# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module Extensions
      module Preview
        # The show action.
        class Show < Terminus::Action
          include Deps[
            "aspects.extensions.renderer",
            repository: "repositories.extension",
            view: "views.extensions.dynamic"
          ]
          include Dry::Monads[:result]

          params { required(:id).filled :integer }

          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            extension = repository.find parameters[:id]

            halt :not_found unless extension

            response.render view, body: body_for(extension)
          end

          private

          def body_for extension
            case renderer.call extension
              in Success(body) then body
              in Failure(message) then message
              else "Unable to render body for extension: #{extension.id}."
            end
          end
        end
      end
    end
  end
end
