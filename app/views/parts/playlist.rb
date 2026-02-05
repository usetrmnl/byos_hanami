# frozen_string_literal: true

require "hanami/view"
require "refinements/struct"

module Terminus
  module Views
    module Parts
      # The playlist presenter.
      class Playlist < Hanami::View::Part
        include Deps[:assets, "aspects.screens.placeholder"]

        using Refinements::Struct

        def current_screen_pill item, label = "Current Screen"
          return unless current_item_id == item.id

          helpers.tag.div label, class: "bit-pill bit-pill-active"
        end

        # :reek:ManualDispatch
        def current_screen
          if current_item_id && respond_to?(:current_item)
            current_item.screen
          else
            placeholder.with id:, image_uri: assets["blank.svg"].path
          end
        end
      end
    end
  end
end
