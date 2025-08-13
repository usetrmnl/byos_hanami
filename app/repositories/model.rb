# frozen_string_literal: true

module Terminus
  module Repositories
    # The model repository.
    class Model < DB::Repository[:model]
      commands :create, delete: :by_pk

      commands :update,
               update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all
        model.order { published_at.asc }
             .to_a
      end

      def find(id) = (model.by_pk(id).one if id)

      def find_by(**) = model.where(**).one

      def find_or_create(key, value, **)
        model.where(key => value).one.then { |record| record || create(name: value, **) }
      end

      # FIX: Remove once the Core Models API can differentiate between company and community models.
      def find_by_dimensions width:, height:
        (find_by(name: "og_png", width:, height:) if width == 800)
      end
    end
  end
end
