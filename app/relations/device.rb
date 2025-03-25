# frozen_string_literal: true

module Terminus
  module Relations
    # The device relation.
    class Device < DB::Relation
      schema :devices, infer: true do
        associations { has_many :device_logs, as: :logs }
      end
    end
  end
end
