# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.extension",
          index_view: "views.extensions.index"
        ]

        contract Contracts::Extensions::Create

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:extension]
            response.render index_view, **view_settings(request, parameters)
          else
            error response, parameters
          end
        end

        private

        def view_settings request, _parameters
          settings = {extensions: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          extensions: repository.all,
                          fields: parameters[:extension],
                          errors: parameters.errors[:extension],
                          layout: false
        end
      end
    end
  end
end
