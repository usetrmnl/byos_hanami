# frozen_string_literal: true

module Terminus
  module Relations
    # The device log relation.
    class DeviceLog < DB::Relation
      schema :device_logs, infer: true do
        associations { belongs_to :device }
      end
    end
  end
end
