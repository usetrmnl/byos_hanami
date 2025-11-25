# frozen_string_literal: true

module Terminus
  module Actions
    module Models
      # The create action.
      class Create < Terminus::Action
        include Deps[:htmx, repository: "repositories.model", index_view: "views.models.index"]

        params do
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

          if parameters.valid?
            repository.create parameters[:model]
            response.render index_view, **view_settings(request)
          else
            error response, parameters
          end
        end

        private

        def view_settings request
          settings = {models: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          models: repository.all,
                          fields: parameters[:model],
                          errors: parameters.errors[:model],
                          layout: false
        end
      end
    end
  end
end
