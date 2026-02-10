# frozen_string_literal: true

module Terminus
  module Aspects
    module Models
      DEFAULTS = {
        description: nil,
        mime_type: "image/png",
        colors: 2,
        bit_depth: 1,
        rotation: 0,
        offset_x: 0,
        offset_y: 0,
        scale_factor: 1,
        width: 800,
        height: 480,
        palette_ids: nil,
        css: nil
      }.freeze
    end
  end
end
