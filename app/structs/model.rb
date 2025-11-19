# frozen_string_literal: true

module Terminus
  module Structs
    # The model struct.
    class Model < DB::Struct
      def liquid_attributes = {bit_depth:, name:, orientation:}

      def orientation = rotation.zero? ? "landscape" : "portrait"
    end
  end
end
