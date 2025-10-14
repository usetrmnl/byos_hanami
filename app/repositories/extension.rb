# frozen_string_literal: true

module Terminus
  module Repositories
    # The extension repository.
    class Extension < DB::Repository[:extension]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        extension.order { created_at.asc }
                 .to_a
      end

      def find(id) = (extension.by_pk(id).one if id)

      def find_by(**) = extension.where(**).one

      def search key, value
        extension.where(Sequel.ilike(key, "%#{value}%"))
                 .order { created_at.asc }
                 .to_a
      end

      def where(**)
        extension.where(**)
                 .order { created_at.asc }
                 .to_a
      end
    end
  end
end
