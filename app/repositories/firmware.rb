# frozen_string_literal: true

module Terminus
  module Repositories
    # The firmware repository.
    class Firmware < DB::Repository[:firmwares]
      commands :create

      commands update: :by_pk,
               use: :timestamps,
               plugins_options: {timestamps: {timestamps: :updated_at}}

      def all = firmwares.by_version_desc.to_a

      def delete id
        find(id).then { it.attachment_destroy if it }
        firmwares.by_pk(id).delete
      end

      def delete_all shrine_store: Hanami.app[:shrine].storages[:store]
        firmwares.where { attachment_data.has_key "id" }
                 .select { attachment_data.get_text("id").as(:attachment_id) }
                 .map(:attachment_id)
                 .each { shrine_store.delete it }

        firmwares.delete
      end

      def find(id) = (firmwares.by_pk(id).one if id)

      def find_by(**) = firmwares.where(**).one

      def latest = all.first
    end
  end
end
