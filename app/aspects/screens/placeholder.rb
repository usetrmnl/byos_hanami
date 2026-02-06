# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # A fallback (null object) for times when you need a screen that behaves like one but isn't.
      Placeholder = Struct.new :id, :label, :name, :image_uri, :width, :height do
        def initialize(
          label: "Placeholder",
          name: "placeholder",
          image_uri: "/assets/setup.svg",
          width: 800,
          height: 480,
          **
        )
          super
        end

        def popover_attributes = {id:, label:, uri: image_uri, width:, height:}
      end
    end
  end
end
