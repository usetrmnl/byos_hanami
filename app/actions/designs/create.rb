# frozen_string_literal: true

module Terminus
  module Actions
    module Designs
      # The create action.
      class Create < Terminus::Action
        include Deps[
          "aspects.screens.upserter",
          repository: "repositories.screen_template",
          model_repository: "repositories.model"
        ]

        params do
          required(:model_id).filled :integer

          required(:template).hash do
            required(:label).filled :string
            required(:name).filled :string
            required(:content).filled :string
          end
        end

        def handle request, response
          parameters = request.params

          if parameters.valid?
            create_with_screen parameters, response
          else
            error response, parameters
          end
        end

        private

        def create_with_screen parameters, response
          template = repository.create parameters[:template]

          upserter.call(model_id: parameters[:model_id], **template.screen_attributes)
          response.redirect_to routes.path(:design_edit, id: template.id)
        end

        def error response, parameters
          response.render view,
                          models: model_repository.all,
                          template: nil,
                          fields: parameters[:template],
                          errors: parameters.errors[:template]
        end
      end
    end
  end
end
