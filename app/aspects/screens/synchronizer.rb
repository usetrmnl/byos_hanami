# frozen_string_literal: true

require "cgi"
require "dry/core"
require "dry/monads"
require "initable"
require "refinements/pathname"
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

        using Refinements::Pathname
        using Refinements::String

        PATTERN = /(-\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2}Z|-\d{10})/

        def initialize(pattern: PATTERN, **)
          @pattern = pattern
          super(**)
        end

        def call display
          url = display.image_url
          pathname = pathname_from display.filename, url

          return Failure "Invalid URL: #{url}." if pathname.extname == "."

          downloader.call(url).bind { |response| upsert pathname, response, find_screen(pathname) }
        end

        private

        attr_reader :struct, :pattern, :cgi

        def pathname_from file_name, url
          Pathname "#{file_name.gsub pattern, Dry::Core::EMPTY_STRING}.#{type_for url}"
        end

        def type_for uri
          cgi.parse(uri)
             .fetch("response-content-type", Dry::Core::EMPTY_ARRAY)
             .first
             .to_s
             .sub("image/", Dry::Core::EMPTY_STRING)
        end

        def find_screen pathname
          screen_repository.find_by(name: pathname.name.to_s).tap { it.image_destroy if it }
        end

        def upsert pathname, response, screen
          upload_attachment(pathname, response).bind do |struct|
            if screen
              update screen, struct
            else
              metadata = struct.image_attributes.fetch :metadata, Dry::Core::EMPTY_HASH
              model = model_repository.find_by(**metadata.slice(:width, :height))

              create pathname.name.to_s, struct, model
            end
          end
        end

        def upload_attachment pathname, response
          struct.upload StringIO.new(response), metadata: {"filename" => pathname}
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
