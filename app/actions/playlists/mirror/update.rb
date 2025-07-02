# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Mirror
        # The update action.
        class Update < Hanami::Action
          include Deps[
            repository: "repositories.playlist",
            device_repository: "repositories.device",
            show_view: "views.playlists.show",
            edit_view: "views.playlists.mirror.edit"
          ]

          params do
            required(:id).filled :integer

            optional(:mirror).filled(:hash) { required(:device_ids).array :integer }
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            status = device_repository.mirror_playlist parameters.dig(:mirror, :device_ids),
                                                       parameters[:id]

            if status
              response.render show_view, **show_view_settings(request, parameters)
            else
              response.render edit_view, **edit_view_settings(request, parameters)
            end
          end

          private

          def show_view_settings request, parameters
            settings = {playlist: repository.find(parameters[:id])}

            settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
            settings
          end

          def edit_view_settings request, parameters
            settings = {playlist: repository.find(parameters[:id]), devices: device_repository.all}
            settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
            settings
          end
        end
      end
    end
  end
end
