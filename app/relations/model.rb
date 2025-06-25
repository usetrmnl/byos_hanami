# frozen_string_literal: true

module Terminus
  module Relations
    # The model relation.
    class Model < DB::Relation
      schema :model, infer: true do
        associations { has_many :devices }
        associations { has_many :screens, relation: :screen }
      end
    end
  end
end
