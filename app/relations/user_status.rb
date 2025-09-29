# frozen_string_literal: true

module Terminus
  module Relations
    # The user status relation.
    class UserStatus < DB::Relation
      schema :user_status, infer: true
    end
  end
end
