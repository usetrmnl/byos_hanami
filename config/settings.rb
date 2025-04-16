# frozen_string_literal: true

require "terminus/ip_finder"
require "terminus/types"

module Terminus
  # The application base settings.
  class Settings < Hanami::Settings
    setting :api_uri,
            constructor: Types::Params::String,
            default: "http://#{IPFinder.new.wired}:2300"

    setting :firmware_root,
            constructor: Terminus::Types::Pathname,
            default: Hanami.app.root.join("public/assets/firmware")

    setting :previews_root,
            constructor: Terminus::Types::Pathname,
            default: Hanami.app.root.join("public/assets/previews")

    setting :screens_root,
            constructor: Terminus::Types::Pathname,
            default: Hanami.app.root.join("public/assets/screens")
  end
end
