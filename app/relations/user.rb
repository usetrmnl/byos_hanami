# frozen_string_literal: true

module Terminus
  module Relations
    # The user relation.
    class User < DB::Relation
      schema :user, infer: true do
        associations { has_many :memberships, relation: :membership }
      end
    end
  end
end
