# auto_register: false
# frozen_string_literal: true

module Terminus
  module Uploaders
    # Processes image uploads.
    class Image < Hanami.app[:shrine]
      include Deps[:mini_magick]

      add_metadata :bit_depth do |io|
        mini_magick::Image.open(io.path).data["depth"] if io.respond_to? :path
      end

      Attacher.validate do
        validate_mime_type %w[image/bmp image/png]
        validate_extension %w[bmp png]
      end
    end
  end
end
