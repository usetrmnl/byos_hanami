# frozen_string_literal: true

require "terminus/ip_finder"
require "terminus/types"

module Terminus
  # The application base settings.
  class Settings < Hanami::Settings
    setting :api_uri, constructor: Types::String, default: "http://#{IPFinder.new.wired}:2300"
    setting :api_access_token_period, constructor: Types::Params::Integer, default: 1_800

    setting :app_secret,
            constructor: Types::String.constrained(filled: true),
            default: SecureRandom.hex(40)

    setting :color_maps_root,
            constructor: Terminus::Types::Pathname,
            default: Hanami.app.root.join("public/assets/color_maps")

    setting :git_tag,
            constructor: Types::String.constrained(filled: true),
            default: `git tag --list --sort=taggerdate | tail -n 1`.strip

    setting :git_sha,
            constructor: Types::String.constrained(filled: true),
            default: `git rev-parse --short HEAD`.strip

    setting :browser, constructor: Terminus::Types::Browser, default: "{}"
    setting :firmware_poller, constructor: Types::Bool, default: true
    setting :model_poller, constructor: Types::Bool, default: true
    setting :screen_poller, constructor: Types::Bool, default: true
  end
end
