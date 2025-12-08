# frozen_string_literal: true

module Terminus
  module Relations
    # The screen relation.
    class Screen < DB::Relation
      schema :screen, infer: true do
        associations { belongs_to :model, relation: :model }
      end

      def ordered = select_append(playlist_item[:position]).order :position
    end
  end
end
