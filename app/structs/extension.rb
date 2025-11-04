# frozen_string_literal: true

require "dry/core"

module Terminus
  module Structs
    # The extension struct.
    class Extension < DB::Struct
      def screen_label = "Extension #{label}"

      def screen_name = "extension-#{name}"

      def screen_attributes = {label: screen_label, name: screen_name}
    end
  end
end
