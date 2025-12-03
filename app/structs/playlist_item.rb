# frozen_string_literal: true

module Terminus
  module Structs
    # The playlist item struct.
    class PlaylistItem < DB::Struct
      def cloneable_attributes
        {
          screen_id:,
          position:,
          repeat_interval:,
          repeat_type:,
          repeat_days:,
          last_day_of_month:,
          start_at:,
          stop_at:,
          hidden_at:
        }
      end
    end
  end
end
