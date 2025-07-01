# frozen_string_literal: true

module Terminus
  module Relations
    # The screen relation.
    class Screen < DB::Relation
      schema :screen, infer: true do
        associations { belongs_to :model, relation: :model }
      end
    end
  end
end
