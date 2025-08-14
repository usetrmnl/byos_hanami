# frozen_string_literal: true

require "terminus/ip_finder"
require "terminus/types"

module Terminus
  # The application base settings.
  class Settings < Hanami::Settings
    setting :api_uri,
            constructor: Types::Params::String,
            default: "http://#{IPFinder.new.wired}:2300"

    setting :color_maps_root,
            constructor: Terminus::Types::Pathname,
            default: Hanami.app.root.join("public/assets/color_maps")

    setting :firmware_poller, constructor: Types::Params::Bool, default: true
    setting :model_poller, constructor: Types::Params::Bool, default: true
    setting :screen_poller, constructor: Types::Params::Bool, default: true
  end
end
