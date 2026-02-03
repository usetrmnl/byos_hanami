# frozen_string_literal: true

require "dry/core"
require "dry/monads"

module Terminus
  module Repositories
    # The screen repository.
    class Screen < DB::Repository[:screen]
      include Dry::Monads[:result]

      commands :create

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        with_associations.order { updated_at.desc }
                         .to_a
      end

      def delete id
        find(id).then { it.image_destroy if it }
        screen.by_pk(id).delete
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      def search key, value
        with_associations.where(Sequel.ilike(key, "%#{value}%"))
                         .order { created_at.asc }
                         .to_a
      end

      def upsert_with_image path, mold, struct
        record = find_by name: mold.name, model_id: mold.model_id
        record ? update_with_image(path, mold, record) : create_with_image(path, mold, struct)
      end

      def where(**)
        with_associations.where(**)
                         .order { created_at.asc }
                         .to_a
      end

      private

      def with_associations = screen.combine :model

      def create_with_image path, mold, struct
        path.open { |io| struct.upload io, metadata: {"filename" => mold.filename} }
        create image_data: struct.image_attributes, **mold.image_attributes
      end

      def update_with_image path, mold, record
        path.open { |io| record.replace io, metadata: {"filename" => mold.filename} }
        update record.id, image_data: record.image_attributes, **mold.image_attributes
      end
    end
  end
end
