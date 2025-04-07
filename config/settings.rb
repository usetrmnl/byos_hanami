# frozen_string_literal: true

require "terminus/ip_finder"

module Terminus
  # The application base settings.
  class Settings < Hanami::Settings
    setting :api_uri,
            constructor: Types::Params::String,
            default: "http://#{IPFinder.new.wired}:2300"

    setting :screens_root,
            constructor: Types::Params::String,
            default: Hanami.app.root.join("public/assets/screens").to_s

    setting :firmware_root,
            constructor: Types::Params::String,
            default: Hanami.app.root.join("public/assets/firmware").to_s
  end
end
