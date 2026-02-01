# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # Updates screen with optional image replacement.
      class Updater
        include Dry::Monads[:result]
        include Deps[
          "aspects.screens.creators.encoded_path",
          "aspects.screens.creators.preprocessed_path",
          "aspects.screens.creators.temp_path",
          "aspects.screens.creators.unprocessed_path",
          repository: "repositories.screen",
          model_repository: "repositories.model"
        ]
        include Initable[mold: Mold]

        def call screen, **parameters
          case parameters
            in data: _ then update_from_data screen, parameters
            in uri: _, preprocessed: true then update_from_preprocessed screen, parameters
            in uri: _ then update_from_unprocessed screen, parameters
            in content: _ then update_from_content screen, parameters
            else Success repository.update(screen.id, **parameters)
          end
        end

        private

        def update_from_content screen, parameters
          build_mold(screen, parameters).bind { |instance| screenshot instance, screen, parameters }
        end

        def update_from_data screen, parameters
          build_mold_for_uri(screen, parameters, parameters[:data]).bind do |instance|
            encode instance, screen, parameters
          end
        end

        def update_from_preprocessed screen, parameters
          build_mold_for_uri(screen, parameters, parameters[:uri]).bind do |instance|
            preprocess instance, screen, parameters
          end
        end

        def update_from_unprocessed screen, parameters
          build_mold_for_uri(screen, parameters, parameters[:uri]).bind do |instance|
            fetch instance, screen, parameters
          end
        end

        def build_mold screen, parameters
          attributes = screen.to_h
                             .slice(:model_id, :label, :name)
                             .merge!(parameters.slice(:model_id, :label, :name, :content))

          find_model(attributes[:model_id]).fmap do |model|
            mold.for(model, **attributes.slice(:label, :name, :content))
          end
        end

        def build_mold_for_uri screen, parameters, content
          attributes = screen.to_h
                             .slice(:model_id, :label, :name)
                             .merge!(parameters.slice(:model_id, :label, :name))
                             .merge!(content:)

          find_model(attributes[:model_id]).fmap do |model|
            mold.for(model, **attributes.slice(:label, :name, :content))
          end
        end

        def find_model id
          model_repository.find(id).then do |record|
            record ? Success(record) : Failure("Unable to find model for ID: #{id}.")
          end
        end

        def screenshot mold, screen, parameters
          temp_path.call(mold) { |path| replace path, screen, **parameters }
        end

        def encode mold, screen, parameters
          encoded_path.call(mold) { |path| replace path, screen, **parameters.except(:data) }
        end

        def preprocess mold, screen, parameters
          preprocessed_path.call mold do |path|
            replace path, screen, **parameters.except(:uri, :preprocessed)
          end
        end

        def fetch mold, screen, parameters
          unprocessed_path.call(mold) { |path| replace path, screen, **parameters.except(:uri) }
        end

        def replace(path, screen, **)
          path.open { |io| screen.replace io, metadata: {"filename" => path.basename} }
          Success repository.update(screen.id, image_data: screen.image_attributes, **)
        end
      end
    end
  end
end
