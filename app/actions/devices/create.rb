# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.device",
          model_repository: "repositories.model",
          playlist_repository: "repositories.playlist",
          new_view: "views.devices.new",
          index_view: "views.devices.index"
        ]

        contract Contracts::Devices::Create

        def handle request, response
          parameters = request.params

          if parameters.valid?
            repository.create parameters[:device]
            response.render index_view, **view_settings(request, parameters)
          else
            render_new response, parameters
          end
        end

        private

        def view_settings request, _parameters
          settings = {devices: repository.all}
          settings[:layout] = false if htmx.request(**request.env).request?
          settings
        end

        def render_new response, parameters
          response.render new_view,
                          models: model_repository.all,
                          playlists: playlist_repository.all,
                          device: nil,
                          fields: parameters[:device],
                          errors: parameters.errors[:device],
                          layout: false
        end
      end
    end
  end
end
