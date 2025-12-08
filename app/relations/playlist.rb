# frozen_string_literal: true

module Terminus
  module Relations
    # The playlist relation.
    class Playlist < DB::Relation
      schema :playlist, infer: true do
        associations do
          belongs_to :current_item, relation: :playlist_item
          has_many :devices, relation: :device
          has_many :playlist_items, relation: :playlist_item, as: :playlist_items
          has_many :screens,
                   through: :playlist_item,
                   relation: :screen,
                   as: :screens,
                   view: :ordered
        end
      end
    end
  end
end
