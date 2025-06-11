# frozen_string_literal: true

require "trmnl/api"

module Terminus
  module Aspects
    module Firmware
      # A firmware attachment synchronizer with Core server.
      class Synchronizer
        include Deps[repository: "repositories.firmware"]
        include Dependencies[:downloader]
        include Dry::Monads[:result]

        def initialize(struct: Structs::Firmware.new, api: TRMNL::API::Client.new, **)
          @struct = struct
          @api = api
          super(**)
        end

        def call
          result = api.firmware

          case result
            in Success(payload) then download(payload).bind { attach it, payload.version }
            else result
          end
        end

        private

        attr_reader :struct, :api

        def download(payload) = downloader.call payload.url

        def attach response, version
          record = repository.find_by_version version

          return Success record if record

          upload = struct.upload StringIO.new(response), metadata: {"filename" => "#{version}.bin"}

          if struct.valid?
            Success repository.create(version: version, attachment_data: upload.data)
          else
            Failure upload.errors
          end
        end
      end
    end
  end
end
