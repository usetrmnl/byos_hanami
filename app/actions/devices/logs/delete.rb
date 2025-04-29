# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      module Logs
        # The delete action.
        class Delete < Terminus::Action
          include Deps[repository: "repositories.device_log"]

          using Refines::Actions::Response

          params do
            required(:device_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            repository.delete_by_device(*parameters.to_h.values_at(:device_id, :id))
            response.with body: "", status: 200
          end
        end
      end
    end
  end
end
