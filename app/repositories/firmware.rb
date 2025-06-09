# frozen_string_literal: true

module Terminus
  module Repositories
    # The firmware repository.
    class Firmware < DB::Repository[:firmwares]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        firmwares.order { version.desc }
                 .to_a
      end

      def find(id) = (firmwares.by_pk(id).one if id)

      def find_by_version(value) = firmwares.where(version: value).one
    end
  end
end
