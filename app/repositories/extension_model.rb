# frozen_string_literal: true

module Terminus
  module Repositories
    # The extension model repository.
    class ExtensionModel < DB::Repository[:extension_model]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        extension_model.order { created_at.asc }
                       .to_a
      end

      def find(id) = (extension_model.by_pk(id).one if id)

      def find_by(**) = extension_model.where(**).one

      def where(**)
        extension_model.where(**)
                       .order { created_at.asc }
                       .to_a
      end
    end
  end
end
