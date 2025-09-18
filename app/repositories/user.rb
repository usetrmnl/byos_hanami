# frozen_string_literal: true

module Terminus
  module Repositories
    # The user repository.
    class User < DB::Repository[:user]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        user.order { created_at.asc }
            .to_a
      end

      def find(id) = (user.by_pk(id).one if id)

      def find_by(**) = user.where(**).one

      def search key, value
        user.where(Sequel.ilike(key, "%#{value}%"))
            .order { created_at.asc }
            .to_a
      end

      def where(**)
        user.where(**)
            .order { created_at.asc }
            .to_a
      end
    end
  end
end
