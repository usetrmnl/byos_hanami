# frozen_string_literal: true

require "hanami/view"
require "initable"

module Terminus
  module Views
    module Parts
      # The device presenter.
      class Device < Hanami::View::Part
        include Initable[fetcher: proc { Terminus::Images::Fetcher.new }]
        include Deps[:settings]

        def image_uri
          fetcher.call(
            Pathname(settings.images_root).join("generated"),
            images_uri: "https://localhost:2443/assets/images"
          )[:image_url]
        end
      end
    end
  end
end
