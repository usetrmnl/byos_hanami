# frozen_string_literal: true

module Terminus
  module Repositories
    # The user repository.
    class UserStatus < DB::Repository[:user_status]
      def all = user_status.to_a

      def find(id) = (user_status.by_pk(id).one if id)

      def find_by(**) = user_status.where(**).one
    end
  end
end
