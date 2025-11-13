# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Mirror
        # The edit action.
        class Edit < Terminus::Action
          include Deps[
            :htmx,
            repository: "repositories.playlist",
            device_repository: "repositories.device"
          ]

          params { required(:id).filled :integer }

          def handle request, response
            parameters = request.params

            halt :unprocessable_content unless parameters.valid?

            response.render view, **view_settings(request, parameters)
          end

          private

          def view_settings request, parameters
            settings = {playlist: repository.find(parameters[:id]), devices: device_repository.all}
            settings[:layout] = false if htmx.request? request.env, :request, "true"
            settings
          end
        end
      end
    end
  end
end
