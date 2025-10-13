# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The screen presenter.
      class Screen < Hanami::View::Part
        def dimensions = width && height ? "#{width}x#{height}" : "Unknown"

        def type = mime_type ? mime_type.delete_prefix("image/").upcase : "Unknown"
      end
    end
  end
end
