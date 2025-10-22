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

          def handle request, response
            id, model_id = request.params.to_h.values_at :id, :model_id
            extension = repository.find id

            halt :not_found unless extension

            if model_id
              response.render view, body: body_for(extension, model_id)
            else
              render_error response
            end
          end

          private

          def body_for extension, model_id
            case renderer.call extension, model_id
              in Success(body) then body
              in Failure(message) then message
              else "Unable to render body for extension: #{extension.id}."
            end
          end

          def render_error response
            response.render view, body: <<~CONTENT
              <div class="screen screen--4bit screen--v2 screen--lg screen--landscape screen--1x">
                <div class="view view--full">
                  <span class="value">
                    No model selected.
                  </span>
                </div>
              </div>
            CONTENT
          end
        end
      end
    end
  end
end
