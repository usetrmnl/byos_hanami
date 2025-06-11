# auto_register: false
# frozen_string_literal: true

module Terminus
  module Uploaders
    # Processes image uploads.
    class Image < Hanami.app[:shrine]
      Attacher.validate do
        validate_mime_type %w[image/bmp image/png]
        validate_extension %w[bmp png]
      end
    end
  end
end
