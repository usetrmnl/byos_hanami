# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      module Logs
        # The show action.
        class Show < Terminus::Action
          include Deps[
            device_repository: "repositories.device",
            log_repository: "repositories.device_log"
          ]

          params do
            required(:device_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            device = device_repository.find parameters[:device_id]
            log = log_repository.find parameters[:id]

            response.render view, device:, log:
          end
        end
      end
    end
  end
end
