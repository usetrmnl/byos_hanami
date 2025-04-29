# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      module Logs
        # The index action.
        class Index < Terminus::Action
          include Deps[
            device_repository: "repositories.device",
            repository: "repositories.device_log"
          ]

          params do
            required(:device_id).filled :integer
            optional(:query).filled :string
          end

          # :reek:TooManyStatements
          def handle request, response
            parameters = request.params
            query = parameters[:query]
            device = device_repository.find parameters[:device_id]
            logs = repository.all_by_message device.id, query

            if request.get_header("HTTP_HX_TRIGGER") == "search"
              add_htmx_headers response, device, query
              response.render view, device:, logs:, layout: false
            else
              response.render view, device:, logs:
            end
          end

          private

          def add_htmx_headers response, device, query
            return unless query

            response.headers["HX-Push-Url"] = routes.path :device_logs, device_id: device.id, query:
          end
        end
      end
    end
  end
end
