# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The update action.
      class Update < Terminus::Action
        include Deps[
          repository: "repositories.device",
          model_repository: "repositories.model",
          playlist_repository: "repositories.playlist",
          show_view: "views.devices.show"
        ]

        contract Contracts::Devices::Update

        def handle request, response
          parameters = request.params
          device = repository.find parameters[:id]

          halt :unprocessable_content unless device

          if parameters.valid?
            save device, parameters, response
          else
            error device, parameters, response
          end
        end

        private

        def save device, parameters, response
          id = device.id
          repository.update id, **parameters[:device]

          response.render show_view, device: repository.find(id), layout: false
        end

        def error device, parameters, response
          response.render view,
                          models: model_repository.all,
                          playlists: playlist_repository.all,
                          device:,
                          fields: parameters[:device],
                          errors: parameters.errors[:device],
                          layout: false
        end
      end
    end
  end
end
