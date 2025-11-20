# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Actions
    module Devices
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          "aspects.devices.provisioner",
          repository: "repositories.device",
          model_repository: "repositories.model",
          playlist_repository: "repositories.playlist",
          index_view: "views.devices.index"
        ]

        include Dry::Monads[:result]

        contract Contracts::Devices::Create

        def handle request, response
          parameters = request.params

          case provision parameters
            in Success then response.render(index_view, **view_settings(request))
            else error response, parameters
          end
        end

        private

        def provision parameters
          parameters.valid? ? provisioner.call(**parameters[:device]) : Failure
        end

        def view_settings request
          settings = {devices: repository.all}
          settings[:layout] = false if htmx.request? request.env, :request, "true"
          settings
        end

        def error response, parameters
          response.render view,
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
