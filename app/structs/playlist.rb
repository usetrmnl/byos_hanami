# frozen_string_literal: true

module Terminus
  module Structs
    # The playlist struct.
    class Playlist < DB::Struct
      def automatic? = mode == "automatic"

      def current_item_position(default: 1) = current_item ? current_item.position : default

      def manual? = mode == "manual"
    end
  end
end
