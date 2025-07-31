# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates error with problem details for device.
      # :reek:DataClump
      class Gaffer
        include Deps[
          "aspects.screens.creator",
          "aspects.screens.creators.temp_path",
          repository: "repositories.screen",
          model_repository: "repositories.model",
          view: "views.gaffe.new"
        ]
        include Initable[payload: Creators::Payload]
        include Dry::Monads[:result]

        def call device, message
          repository.find_by(name: device.system_name("error"))
                    .then do |screen|
                      screen ? update(screen, device, message) : create(device, message)
                    end
        end

        def create device, message
          creator.call content: String.new(view.call(message:)),
                       **device.system_screen_attributes("error")
        end

        def update screen, device, message
          screen.image_destroy

          temp_path.call build_payload(device, message) do |path|
            screen.upload StringIO.new(path.read),
                          metadata: {"filename" => "#{device.system_name :error}.png"}

            Success repository.update(screen.id, image_data: screen.image_attributes)
          end
        end

        # :reek:FeatureEnvy
        def build_payload device, message
          payload[
            model: model_repository.find(device.model_id),
            label: device.system_label("Error"),
            name: device.system_name("error"),
            content: String.new(view.call(message:))
          ]
        end
      end
    end
  end
end
