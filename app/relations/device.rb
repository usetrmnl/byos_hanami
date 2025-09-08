# frozen_string_literal: true

module Terminus
  module Relations
    # The device relation.
    class Device < DB::Relation
      schema :device, infer: true do
        associations do
          belongs_to :model, relation: :model
          belongs_to :playlist, relation: :playlist
          has_many :device_logs, as: :logs
        end
      end
    end
  end
end
