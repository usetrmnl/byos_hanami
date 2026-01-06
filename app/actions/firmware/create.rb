# frozen_string_literal: true

module Terminus
  module Actions
    module Firmware
      # The create action.
      class Create < Action
        include Deps[
          :htmx,
          repository: "repositories.firmware",
          index_view: "views.firmware.index"
        ]

        params { required(:firmware).filled(:hash, Schemas::Firmware::Upsert) }

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:firmware]
            response.render index_view, **view_settings(request)
          else
            error response, parameters
          end
        end

        private

        def view_settings request
          settings = {firmware: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
                          firmware: nil,
                          fields: parameters[:firmware],
                          errors: parameters.errors[:firmware],
                          layout: false
        end
      end
    end
  end
end
