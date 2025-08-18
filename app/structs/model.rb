# frozen_string_literal: true

module Terminus
  module Structs
    # The model struct.
    class Model < DB::Struct
      def crop = "#{dimensions}+#{offset_x}+#{offset_y}"

      def cropable? = !offset_x.zero? || !offset_y.zero?

      def dimensions = "#{width}x#{height}"

      def rotatable? = rotation.positive?
    end
  end
end
