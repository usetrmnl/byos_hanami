# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The update action.
      class Update < Terminus::Action
        include Deps[
          repository: "repositories.device",
          show_view: "views.devices.show",
          edit_view: "views.devices.edit"
        ]

        params do
          required(:id).filled :integer
          required(:device).hash Contracts::API::Device
        end

        def handle request, response
          parameters = request.params
          device = repository.find parameters[:id]

          halt :unprocessable_entity unless device

          if parameters.valid?
            save device, parameters, response
          else
            edit device, parameters, response
          end
        end

        private

        def save device, parameters, response
          id = device.id
          repository.update id, **parameters[:device]
          response.render show_view, device: repository.find(id), layout: false
        end

        # :reek:FeatureEnvy
        def edit device, parameters, response
          response.render edit_view,
                          device:,
                          fields: parameters[:device],
                          errors: parameters.errors[:device],
                          layout: false
        end
      end
    end
  end
end
