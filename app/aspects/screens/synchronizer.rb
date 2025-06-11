# frozen_string_literal: true

require "cgi"
require "dry/core"
require "dry/monads"
require "initable"
require "refinements/string"

module Terminus
  module Aspects
    module Screens
      # A screen attachment synchronizer with Core server.
      class Synchronizer
        include Deps[
          model_repository: "repositories.model",
          screen_repository: "repositories.screen"
        ]

        include Dependencies[:downloader, :logger]
        include Initable[struct: proc { Terminus::Structs::Screen.new }, cgi: CGI]
        include Dry::Monads[:result]

        using Refinements::String

        def call display
          url = display.image_url
          name = "#{display.filename}.#{type_for url}"

          return Failure "Invalid URL: #{url}." if name.end_with? "."

          downloader.call(url).bind { |response| upsert name, response, find_screen(name) }
        end

        private

        def type_for uri
          cgi.parse(uri)
             .fetch("response-content-type", Dry::Core::EMPTY_ARRAY)
             .first
             .to_s
             .sub("image/", Dry::Core::EMPTY_STRING)
        end

        def find_screen(name) = screen_repository.find_by(name:).tap { it.image_destroy if it }

        def upsert name, response, screen
          upload_attachment(name, response).bind do |struct|
            if screen
              update screen, struct
            else
              metadata = struct.image_attributes.fetch :metadata, Dry::Core::EMPTY_HASH
              model = model_repository.find_by(**metadata.slice(:width, :height))

              create name, struct, model
            end
          end
        end

        def upload_attachment name, response
          struct.upload StringIO.new(response), metadata: {"filename" => name}
          struct.valid? ? Success(struct) : Failure(struct.errors)
        end

        def update screen, struct
          Success screen_repository.update screen.id, image_data: struct.image_attributes
        end

        def create name, struct, model
          return log_failure unless model

          Success(
            screen_repository.create(
              model_id: model.id,
              name:,
              label: name.sub(/\..+$/, "").titleize,
              image_data: struct.image_attributes
            )
          )
        end

        def log_failure
          logger.error { "Unable to find model for screen." }
          Failure()
        end
      end
    end
  end
end
