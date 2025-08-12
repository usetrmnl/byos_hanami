# frozen_string_literal: true

require "cogger"
require "containable"
require "http"
require "sanitize"

module Terminus
  # Registers application dependencies.
  module LibContainer
    extend Containable

    register :http do
      HTTP.default_options = ::HTTP::Options.new features: {logging: {logger: self[:logger]}}
      HTTP
    end

    register(:downloader) { Downloader.new }
    register(:sanitizer) { Sanitizer.new }

    register :logger do
      Cogger.add_filter(:api_key)
            .add_filter(:mac_address)
            .add_filter(:HTTP_ACCESS_TOKEN)
            .add_filter(:HTTP_ID)
            .new id: :terminus, formatter: :property
    end
  end
end
