# frozen_string_literal: true

require "initable"
require "refinements/pathname"

module Terminus
  module Aspects
    module Firmware
      # Fetches latest firmware download.
      class Fetcher
        include Deps[:settings]
        include Initable[public_root: proc { Hanami.app.root.join("public") }, model: Model]

        using Refinements::Pathname

        def call
          settings.firmware_root.files("*.bin").reverse.map do |path|
            model[
              path: build_relative(path),
              size: path.size,
              uri: build_uri(path),
              version: path.name.to_s
            ]
          end
        end

        private

        def build_relative(path) = path.relative_path_from public_root

        def build_uri path
          build_relative(path).then { |relative_path| "#{settings.api_uri}/#{relative_path}" }
        end
      end
    end
  end
end
