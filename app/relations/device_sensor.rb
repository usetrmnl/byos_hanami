# frozen_string_literal: true

module Terminus
  module Relations
    # The device sensor relation.
    class DeviceSensor < DB::Relation
      schema :device_sensor, infer: true do
        associations { belongs_to :device, relation: :device }
      end
    end
  end
end
