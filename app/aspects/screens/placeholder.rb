# frozen_string_literal: true

require "wholeable"

module Terminus
  module Aspects
    module Screens
      # A fallback (null object) for times when you need a screen that behaves like one but isn't.
      class Placeholder
        include Wholeable[:id, :label, :name, :uri, :width, :height]
        include Deps[:assets]

        def initialize(
          id: 0,
          label: "Placeholder",
          name: "placeholder",
          uri: "setup.svg",
          width: 800,
          height: 480,
          **
        )
          @id = id
          @label = label
          @name = name
          @uri = uri
          @width = width
          @height = height
          super(**)
        end

        def image_uri = assets[uri].path

        def popover_attributes = {id:, label:, uri: image_uri, width:, height:}
      end
    end
  end
end
