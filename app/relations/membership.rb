# frozen_string_literal: true

module Terminus
  module Relations
    # The membership relation.
    class Membership < DB::Relation
      schema :membership, infer: true do
        associations do
          belongs_to :account, relation: :account
          belongs_to :user, relation: :user
        end
      end
    end
  end
end
