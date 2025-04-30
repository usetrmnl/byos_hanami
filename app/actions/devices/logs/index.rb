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
            optional(:query).maybe :string
          end

          # :reek:TooManyStatements
          # rubocop:todo Metrics/MethodLength
          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            query = parameters[:query].to_s
            device = device_repository.find parameters[:device_id]
            logs = load_logs device.id, query

            if request.get_header("HTTP_HX_TRIGGER") == "search"
              add_htmx_headers response, device, query
              response.render view, device:, logs:, query:, layout: false
            else
              response.render view, device:, logs:, query:
            end
          end
          # rubocop:enable Metrics/MethodLength

          private

          def load_logs device_id, query
            return repository.all_by_device device_id if query.empty?

            repository.all_by_message device_id, query
          end

          def add_htmx_headers response, device, query
            return if query.empty?

            response.headers["HX-Push-Url"] = routes.path :device_logs, device_id: device.id, query:
          end
        end
      end
    end
  end
end
