# frozen_string_literal: true

module Terminus
  module Relations
    # The account relation.
    class Account < DB::Relation
      schema :account, infer: true do
        associations do
          has_many :memberships, relation: :membership

          # FIX: With or without the relation doesn't causes exceptions.
          # has_many :users, through: :memberships, relation: :user
        end
      end
    end
  end
end
