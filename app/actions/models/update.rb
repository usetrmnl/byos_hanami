# frozen_string_literal: true

module Terminus
  module Actions
    module Models
      # The update action.
      class Update < Terminus::Action
        include Deps[repository: "repositories.model", show_view: "views.models.show"]

        params do
          required(:id).filled :integer

          required(:model).filled(:hash) do
            required(:name).filled :string
            required(:label).filled :string
            required(:description).maybe :string
            required(:mime_type).filled :string
            required(:colors).filled :integer
            required(:bit_depth).filled :integer
            required(:rotation).filled :integer
            required(:offset_x).filled :integer
            required(:offset_y).filled :integer
            required(:scale_factor).filled :float
            required(:width).filled :integer
            required(:height).filled :integer
            required(:published_at).maybe :date_time
          end
        end

        def handle request, response
          parameters = request.params
          model = repository.find parameters[:id]

          halt :unprocessable_content unless model

          if parameters.valid?
            save model, parameters, response
          else
            error model, parameters, response
          end
        end

        private

        def save model, parameters, response
          id = model.id
          repository.update id, **parameters[:model]

          response.render show_view, model: repository.find(id), layout: false
        end

        def error model, parameters, response
          response.render view,
                          model:,
                          fields: parameters[:model],
                          errors: parameters.errors[:model],
                          layout: false
        end
      end
    end
  end
end
