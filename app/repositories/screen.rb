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

      def create_with_image path, mold, struct
        path.open { |io| struct.upload io, metadata: {"filename" => mold.file_name} }
        create image_data: struct.image_attributes, **mold.image_attributes
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

      # :reek:TooManyStatements
      # rubocop:todo Metrics/AbcSize
      def upsert_with_image path, mold, struct
        path.open { |io| struct.upload io, metadata: {"filename" => mold.file_name} }

        attributes = {image_data: Sequel.pg_jsonb(struct.image_attributes), **mold.image_attributes}

        update = attributes.each_key
                           .with_object({updated_at: Sequel.function(:now)}) do |column, all|
                             all[column] = Sequel[:excluded][column]
                           end

        find screen.dataset.insert_conflict(target: %i[model_id name], update:).insert(attributes)
      end
      # rubocop:enable Metrics/AbcSize

      def where(**)
        with_associations.where(**)
                         .order { created_at.asc }
                         .to_a
      end

      private

      def with_associations = screen.combine :model
    end
  end
end
