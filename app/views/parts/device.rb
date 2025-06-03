# frozen_string_literal: true

require "hanami/view"
require "initable"

module Terminus
  module Views
    module Parts
      # The device presenter.
      class Device < Hanami::View::Part
        include Initable[fetcher: proc { Terminus::Aspects::Screens::Fetcher.new }]
        include Deps[:settings]

        def battery_percentage
          case battery
            when 0 then 0
            when ..0.45 then 10
            when 0.46..0.9 then 20
            when 1.0..1.35 then 30
            when 1.36..1.8 then 40
            when 1.81..2.25 then 50
            when 2.26..2.7 then 60
            when 2.71..3.15 then 70
            when 3.16..3.6 then 80
            when 3.61..4.05 then 90
            else 100
          end
        end

        def wifi_percentage
          case wifi
            when 0 then 0
            when ..-91 then 10
            when -90..-81 then 20
            when -80..-71 then 30
            when -70..-67 then 40
            when -66..-62 then 50
            when -61..-57 then 60
            when -56..-52 then 70
            when -51..-47 then 80
            when -46..-40 then 90
            else 100
          end
        end

        def dimensions = "#{width}x#{height}"

        def image_uri = fetcher.call(value)[:image_url].sub(settings.api_uri, "")
      end
    end
  end
end
