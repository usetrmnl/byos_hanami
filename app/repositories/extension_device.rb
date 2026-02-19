# frozen_string_literal: true

module Terminus
  module Repositories
    # The extension device repository.
    class ExtensionDevice < DB::Repository[:extension_device]
      commands :create, delete: :by_pk

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        extension_device.order { created_at.asc }
                        .to_a
      end

      def find(id) = (extension_device.by_pk(id).one if id)

      def find_by(**) = extension_device.where(**).one

      def where(**)
        extension_device.where(**)
                        .order { created_at.asc }
                        .to_a
      end
    end
  end
end
