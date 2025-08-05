# frozen_string_literal: true

module Terminus
  module Relations
    # The playlist relation.
    class Playlist < DB::Relation
      schema :playlist, infer: true do
        associations do
          belongs_to :current_item, relation: :playlist_item
          has_many :devices
        end
      end

      # rubocop:todo Metrics/MethodLength
      def set_current_item id, item_id
        subquery = <<~CONTENT
          id IN (
            SELECT playlist_id
            FROM playlist_item
            GROUP BY playlist_id
            HAVING COUNT(*) = 1
          )
        CONTENT

        where(id:, current_item_id: nil).where(Sequel.lit(subquery))
                                        .update(current_item_id: item_id)
        where(id:).first
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
