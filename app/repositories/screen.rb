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

      def upsert_by_name(value, **)
        find_by_name(value).then do |record|
          return create(name: value, **) unless record

          record.image_destroy
          update(record.id, **)
        end
      end
    end
  end
end
