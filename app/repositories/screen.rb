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

      def create_with_image payload, struct
        name = payload.name

        find_by(name:).then do |record|
          if record
            struct.image_destroy
            Failure "Screen exists with name: #{name.inspect}."
          else
            Success create(image_data: struct.image_attributes, **payload.attributes)
          end
        end
      end

      def delete id
        find(id).then { it.image_destroy if it }
        screen.by_pk(id).delete
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      def update_image(name, io, **)
        find_by(name:).then do |record|
          if record
            record.replace(io, **)
            Success update record.id, image_data: record.image_attributes
          else
            Failure "Unabled to find screen: #{name.inspect}."
          end
        end
      end

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
