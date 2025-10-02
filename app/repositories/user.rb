# frozen_string_literal: true

module Terminus
  module Repositories
    # The user repository.
    class User < DB::Repository[:user]
      commands :create

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        with_status.order { created_at.asc }
                   .to_a
      end

      def find(id) = (with_status.by_pk(id).one if id)

      def find_by(**) = with_status.where(**).one

      def search key, value
        with_status.where(Sequel.ilike(key, "%#{value}%"))
                   .order { created_at.asc }
                   .to_a
      end

      def where(**)
        with_status.where(**)
                   .order { created_at.asc }
                   .to_a
      end

      private

      def with_status = user.combine :status
    end
  end
end
