# frozen_string_literal: true

module Terminus
  module Repositories
    # The screen repository.
    class Screen < DB::Repository[:screen]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        with_associations.order { updated_at.desc }
                         .to_a
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by_name(value) = with_associations.where(name: value).one

      def latest
        with_associations.order { updated_at.desc }
                         .exclude(Sequel.like(:name, "%sleep%"))
                         .first
      end

      def upsert_by_name(value, **)
        find_by_name(value).then do |record|
          return create(name: value, **) unless record

          record.image_destroy
          update(record.id, **)
        end
      end

      private

      def with_associations = screen.combine :model
    end
  end
end
