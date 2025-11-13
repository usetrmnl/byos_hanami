# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Creates error with problem details for device.
      class Gaffer
        include Deps[
          "aspects.screens.creator",
          "aspects.screens.creators.temp_path",
          repository: "repositories.screen",
          view: "views.screens.gaffe.new"
        ]
        include Initable[mold: Mold]
        include Dry::Monads[:result]

        def call device, message
          screen = repository.find_by model_id: device.model_id, name: device.screen_name("error")
          screen_attributes = device.screen_attributes "error"
          content = String.new view.call(body: message)

          if screen
            update device, screen, mold.for(device.model, **screen_attributes, content:)
          else
            creator.call content:, **screen_attributes
          end
        end

        private

        def update device, screen, mold
          temp_path.call mold do |path|
            replace screen.id, path, {"filename" => "#{device.screen_name :error}.png"}
          end
        end

        def replace id, path, metadata
          path.open { |io| repository.update_with_image id, io, image: {metadata:} }
        end
      end
    end
  end
end
