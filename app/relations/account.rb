# frozen_string_literal: true

module Terminus
  module Relations
    # The account relation.
    class Account < DB::Relation
      schema :account, infer: true do
        associations { has_many :memberships, relation: :membership }
      end
    end
  end
end
