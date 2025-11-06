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

      # :reek:TooManyStatements
      def create_with_models attributes, model_ids
        transaction do
          record = create attributes
          associations = model_ids.map { |id| {extension_id: record.id, model_id: id} }

          extension_model.changeset(:create, associations).commit
          record
        end
      end

      def find(id) = (with_associations.by_pk(id).one if id)

      def find_by(**) = with_associations.where(**).one

      def search key, value
        extension.where(Sequel.ilike(key, "%#{value}%"))
                 .order { created_at.asc }
                 .to_a
      end

      # :reek:TooManyStatements
      # rubocop:todo Metrics/AbcSize
      def update_with_models id, attributes, model_ids
        transaction do
          record = update id, attributes

          extension_model.where(extension_id: id).exclude(model_id: model_ids).delete

          old_ids = extension_model.where(extension_id: id, model_id: model_ids).map(:model_id)
          new_ids = model_ids.reject { |id| old_ids.include? id.to_i }
          associations = new_ids.map { |model_id| {extension_id: id, model_id:} }

          extension_model.changeset(:create, associations).commit
          record
        end
      end
      # rubocop:enable Metrics/AbcSize

      def where(**)
        extension.where(**)
                 .order { created_at.asc }
                 .to_a
      end

      private

      def with_associations = extension.combine :models
    end
  end
end
