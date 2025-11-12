# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Extensions
      # Creates or updates associated screen from Liquid content.
      class ScreenUpserter
        include Deps[
          "aspects.extensions.renderer",
          "aspects.screens.creator",
          "aspects.screens.creators.temp_path",
          model_repository: "repositories.model",
          screen_repository: "repositories.screen",
          view: "views.extensions.dynamic"
        ]
        include Initable[mold: Screens::Mold]

        def call extension, model_id
          renderer.call(extension, model_id)
                  .fmap { view.call body: it }
                  .bind { |content| upsert extension, model_id, String.new(content) }
        end

        private

        # :reek:TooManyStatements
        def upsert extension, model_id, content
          name = extension.screen_name
          screen = screen_repository.find_by(model_id:, name:)

          if screen
            model = model_repository.find model_id
            update extension, screen.id, mold.for(model, **extension.screen_attributes, content:)
          else
            creator.call model_id:, label: extension.screen_label, name:, content:
          end
        end

        def update extension, screen_id, mold
          temp_path.call mold do |path|
            replace screen_id, path, {"filename" => "#{extension.screen_name}.png"}
          end
        end

        def replace id, path, metadata
          path.open { |io| screen_repository.update_with_image id, io, image: {metadata:} }
        end
      end
    end
  end
end
