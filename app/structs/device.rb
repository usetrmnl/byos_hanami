# frozen_string_literal: true

module Terminus
  module Structs
    # The device struct.
    class Device < DB::Struct
      def as_api_display = {image_url_timeout: image_timeout, refresh_rate:}
    end
  end
end
