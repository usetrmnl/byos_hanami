# frozen_string_literal: true

module Terminus
  module Repositories
    # The firmware repository.
    class Firmware < DB::Repository[:firmwares]
      commands :create, update: :by_pk

      def all
        firmwares.order { version.desc }
                 .to_a
      end

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

      def find_by_version(value) = firmwares.where(version: value).one

      def latest
        firmwares.order { version.desc }
                 .first
      end
    end
  end
end
