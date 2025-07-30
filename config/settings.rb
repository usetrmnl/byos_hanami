# frozen_string_literal: true

require "terminus/ip_finder"
require "terminus/types"

module Terminus
  # The application base settings.
  class Settings < Hanami::Settings
    setting :api_uri,
            constructor: Types::Params::String,
            default: "http://#{IPFinder.new.wired}:2300"

    setting :firmware_poller, constructor: Types::Params::Bool, default: true
    setting :model_poller, constructor: Types::Params::Bool, default: true
    setting :screen_poller, constructor: Types::Params::Bool, default: true
  end
end
