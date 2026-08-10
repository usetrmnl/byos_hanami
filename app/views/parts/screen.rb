# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The screen presenter.
      class Screen < Hanami::View::Part
        include Deps[:routes]

        def design_link
          return "None" unless template

          helpers.link_to template.label, routes.path(:design, id: template.id)
        end

        def dimensions = width && height ? "#{width}x#{height}" : "Unknown"

        def extension_link
          return "None" unless extension

          helpers.link_to extension.label, routes.path(:extension_edit, id: extension.id)
        end

        def type = mime_type ? mime_type.delete_prefix("image/").upcase : "Unknown"
      end
    end
  end
end
