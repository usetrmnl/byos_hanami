# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      module Logs
        # The index action.
        class Index < Terminus::Action
          include Deps[
            device_repository: "repositories.device",
            log_repository: "repositories.device_log"
          ]

          params { required(:device_id).filled :integer }

          def handle request, response
            parameters = request.params

            device = device_repository.find parameters[:device_id]
            logs = log_repository.all_by_device device.id

            response.render view, device:, logs:
          end
        end
      end
    end
  end
end
