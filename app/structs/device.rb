# frozen_string_literal: true

module Terminus
  module Structs
    # The device struct.
    class Device < DB::Struct
      def display_attributes = {image_url_timeout: image_timeout, refresh_rate: refresh_rate}
    end
  end
end
