# frozen_string_literal: true

module Terminus
  module Repositories
    # The screen repository.
    class Screen < DB::Repository[:screens]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        screens.order { created_at.asc }
               .to_a
      end

      def find(id) = (screens.by_pk(id).one if id)

      def find_by_name(value) = screens.where(name: value).one
    end
  end
end
