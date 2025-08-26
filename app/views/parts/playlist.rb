# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The playlist presenter.
      class Playlist < Hanami::View::Part
        include Deps[:assets]

        def current_pill item
          return unless current_item_id == item.id

          helpers.tag.span "Current", class: "bit-pill bit-active"
        end

        # :reek:ManualDispatch
        def current_screen_uri
          if current_item_id && respond_to?(:current_item)
            current_item.screen.image_uri
          else
            assets["blank.svg"].path
          end
        end
      end
    end
  end
end
