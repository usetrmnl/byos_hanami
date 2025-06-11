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

        include Dependencies[:downloader]
        include Initable[struct: proc { Terminus::Structs::Screen.new }, cgi: CGI]
        include Dry::Monads[:result]

        using Refinements::String

        def call display
          url = display.image_url
          name = "#{display.filename}.#{type_for url}"

          return Failure "Invalid URL: #{url}." if name.end_with? "."

          downloader.call(url).bind { |response| process name, response }
        end

        private

        def type_for uri
          cgi.parse(uri)
             .fetch("response-content-type", Dry::Core::EMPTY_ARRAY)
             .first
             .to_s
             .sub("image/", Dry::Core::EMPTY_STRING)
        end

        def process name, response
          struct.upload StringIO.new(response), metadata: {"filename" => name}

          return Failure struct.errors unless struct.valid?

          model = find_model struct

          return Failure "Unable to associate model with screen." unless model

          upsert name, model, struct
        end

        def find_model struct
          metadata = struct.image_attributes.fetch :metadata, Dry::Core::EMPTY_HASH
          model_repository.find_by(**metadata.slice(:width, :height))
        end

        def upsert name, model, struct
          Success screen_repository.upsert_by_name(
            name,
            model_id: model.id,
            label: name.sub(/\..+$/, "").titleize,
            image_data: struct.image_attributes
          )
        end
      end
    end
  end
end
