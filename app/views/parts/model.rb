# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The model presenter.
      class Model < Hanami::View::Part
        def dimensions = "#{width}x#{height}"

        def kind_label = kind.capitalize

        def type = mime_type ? mime_type.delete_prefix("image/").upcase : "Unknown"
      end
    end
  end
end
