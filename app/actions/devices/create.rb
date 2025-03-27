# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The create action.
      class Create < Terminus::Action
        include Deps[
          repository: "repositories.device",
          new_view: "views.devices.new",
          index_view: "views.devices.index"
        ]

        params do
          required(:device).hash do
            required(:label).filled :string
            required(:friendly_id).filled :string
            required(:mac_address).filled :string
            required(:api_key).filled :string
            required(:refresh_rate).filled :integer
            required(:image_timeout).filled :integer
          end
        end

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

          settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
          settings
        end

        # :reek:FeatureEnvy
        def render_new response, parameters
          response.render new_view,
                          device: nil,
                          fields: parameters[:device],
                          errors: parameters.errors[:device],
                          layout: false
        end
      end
    end
  end
end
