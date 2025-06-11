# frozen_string_literal: true

module Terminus
  module Relations
    # The screen relation.
    class Screen < DB::Relation
      schema :screens, infer: true
    end
  end
end
