# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Devices
        # The delete action.
        class Delete < Base
          include Deps[repository: "repositories.device"]
          include Initable[serializer: Serializers::Device]

          def handle request, response
            device = repository.delete request.params[:id]
            response.body = {data: serializer.new(device).to_h}.to_json
          end
        end
      end
    end
  end
end
