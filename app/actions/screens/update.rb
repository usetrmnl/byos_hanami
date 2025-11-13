# frozen_string_literal: true

module Terminus
  module Actions
    module Screens
      # The update action.
      class Update < Terminus::Action
        include Deps[
          repository: "repositories.screen",
          model_repository: "repositories.model",
          show_view: "views.screens.show"
        ]

        params do
          required(:id).filled :integer

          required(:screen).filled(:hash) do
            required(:model_id).filled :integer
            required(:label).filled :string
            required(:name).filled :string
          end
        end

        def handle request, response
          parameters = request.params
          screen = repository.find parameters[:id]

          halt :unprocessable_content unless screen

          if parameters.valid?
            save screen, parameters, response
          else
            error screen, parameters, response
          end
        end

        private

        def save screen, parameters, response
          id = screen.id
          repository.update id, **parameters[:screen]

          response.render show_view, screen: repository.find(id), layout: false
        end

        def error screen, parameters, response
          response.render view,
                          models: model_repository.all,
                          screen:,
                          fields: parameters[:screen],
                          errors: parameters.errors[:screen],
                          layout: false
        end
      end
    end
  end
end
