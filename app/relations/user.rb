# frozen_string_literal: true

module Terminus
  module Relations
    # The user relation.
    class User < DB::Relation
      schema :user, infer: true do
        associations do
          belongs_to :user_status, relation: :user_status, as: :status
          has_many :memberships, relation: :membership
        end
      end
    end
  end
end
