# frozen_string_literal: true

require "cgi"
require "dry/core"
require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # A screen attachment synchronizer with Core server.
      class Synchronizer
        include Deps[repository: "repositories.screen"]
        include Dependencies[:downloader]
        include Initable[struct: proc { Terminus::Structs::Screen.new }, cgi: CGI]
        include Dry::Monads[:result]

        def call display
          url = display.image_url
          name = "#{display.filename}.#{type_for url}"

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
          struct.attach StringIO.new(response), metadata: {"filename" => name}

          return Failure struct.errors unless struct.valid?

          Success repository.upsert_by_name(name, image_data: struct.finalize.data)
        end
      end
    end
  end
end
