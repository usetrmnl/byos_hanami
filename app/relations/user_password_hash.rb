# frozen_string_literal: true

module Terminus
  module Relations
    # The user password hash relation.
    class UserPasswordHash < DB::Relation
      schema :user_password_hash, infer: true
    end
  end
end
