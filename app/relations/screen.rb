# frozen_string_literal: true

module Terminus
  module Relations
    # The screen relation.
    class Screen < DB::Relation
      schema :screen, infer: true do
        associations do
          belongs_to :model, relation: :model
          belongs_to :extension, relation: :extension
          belongs_to :template, relation: :screen_template
          has_many :playlist_items, relation: :playlist_item, as: :playlist_items, view: :ordered
          has_many :playlists, through: :playlist_item, relation: :playlist, as: :playlists
        end
      end

      def ordered = select_append(playlist_item[:position]).order :position
    end
  end
end
