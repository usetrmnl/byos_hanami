# frozen_string_literal: true

module Terminus
  module Repositories
    # The model repository.
    class Model < DB::Repository[:model]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        model.order { label.asc }
             .to_a
      end

      def delete_all(**) = model.where(**).delete

      def find(id) = (model.by_pk(id).one if id)

      def find_by(**) = model.where(**).one

      def find_or_create(key, value, **)
        model.where(key => value).one.then { |record| record || create(name: value, **) }
      end

      def search key, value
        model.where(Sequel.ilike(key, "%#{value}%"))
             .order { created_at.asc }
             .to_a
      end

      def where(**)
        model.where(**)
             .order { created_at.asc }
             .to_a
      end
    end
  end
end
