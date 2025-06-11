# frozen_string_literal: true

require "cgi"
require "dry/core"
require "dry/monads"
require "initable"

module Terminus
  module Aspects
    module Screens
      # A screen Core attachment synchronizer.
      class Synchronizer
        include Deps[repository: "repositories.screen"]
        include Dependencies[:downloader]
        include Initable[struct: proc { Terminus::Structs::Screen.new }, cgi: CGI]
        include Dry::Monads[:result]

        def call display
          url = display.image_url
          name = "#{display.filename}.#{type_for url}"

          downloader.call(url).bind { attach it, name }
        end

        private

        def type_for uri
          cgi.parse(uri)
             .fetch("response-content-type", Dry::Core::EMPTY_ARRAY)
             .first
             .to_s
             .sub("image/", Dry::Core::EMPTY_STRING)
        end

        def attach response, name
          record = repository.find_by_name name

          return Success record if record

          upload = struct.upload StringIO.new(response), metadata: {"filename" => name}

          if struct.valid_attachment?
            Success repository.create(label: name, name:, attachment: upload.data)
          else
            Failure upload.errors
          end
        end
      end
    end
  end
end
