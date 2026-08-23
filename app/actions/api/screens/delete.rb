# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Screens
        # The delete action.
        class Delete < Base
          include Deps[:settings, repository: "repositories.screen"]
          include Initable[serializer: Serializers::Screen]

          using Refines::Actions::Response

          def handle request, response
            repository.find(request.params[:id]).then do |screen|
              screen ? success(screen, response) : failure(response)
            end
          end

          private

          def success screen, response
            repository.delete screen.id
            response.body = {data: serializer.new(screen).to_h}.to_json
          end

          def failure response
            payload = problem[status: :not_found]
            response.with body: payload.to_json, format: :problem_details, status: payload.status
          end
        end
      end
    end
  end
end
