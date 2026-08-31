# frozen_string_literal: true

require "core"
require "rqrcode"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        QRCode = lambda do |content, size = 11, level = Core::EMPTY_STRING, view = "responsive"|
          level = "h" unless %w[l m q h].include? level.downcase

          RQRCode::QRCode.new(content, level:).as_svg(
            color: "000",
            fill: "fff",
            shape_rendering: "crispEdges",
            module_size: size,
            use_path: true,
            viewbox: view == "responsive",
            svg_attributes: {
              class: "qr-code"
            }
          )
        end
      end
    end
  end
end
