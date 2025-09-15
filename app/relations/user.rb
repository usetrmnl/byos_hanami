# frozen_string_literal: true

module Terminus
  module Relations
    # The user relation.
    class User < DB::Relation
      schema :user, infer: true do
        associations do
          has_many :memberships, relation: :membership

          # FIX: With or without the relation doesn't causes exceptions.
          # has_many :accounts, through: :memberships, relation: :account
        end
      end
    end
  end
end
