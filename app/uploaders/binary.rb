# auto_register: false
# frozen_string_literal: true

module Terminus
  module Uploaders
    # Processes binary uploads.
    class Binary < Shrine
      Attacher.validate do
        validate_mime_type ["application/octet-stream"]
        validate_extension ["bin"]
      end
    end
  end
end
