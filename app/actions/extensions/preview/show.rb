# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      module Preview
        # The show action.
        class Show < Action
          include Deps[
            "aspects.extensions.renderer",
            repository: "repositories.extension",
            view: "views.extensions.dynamic"
          ]

          params do
            required(:extension_id).filled :integer
            required(:model_id).filled :integer
          end

          def handle request, response
            id, model_id = request.params.to_h.values_at :extension_id, :model_id
            extension = repository.find id

            halt :not_found unless extension

            response.render view, body: body_for(extension, model_id)
          end

          private

          def body_for extension, model_id
            case renderer.call(extension, model_id:)
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
