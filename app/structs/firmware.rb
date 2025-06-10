# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Structs
    # The firmware struct.
    class Firmware < DB::Struct
      include Terminus::Uploaders::Binary::Attachment[:attachment]

      using Refinements::Hash

      attr_reader :attachment_data

      def initialize(*, store: Hanami.app[:shrine].storages[:store])
        super(*)
        @store = store
        @attacher = attachment_attacher
      end

      def attachment_attributes = attributes[:attachment_data].deep_symbolize_keys

      def attachment_destroy
        store.delete attachment_id
        attributes[:attachment_data].clear
      end

      def attachment_id = attachment_attributes[:id]

      def attachment_name = attachment_attributes.dig :metadata, :filename

      def attachment_size = attachment_attributes.dig :metadata, :size

      def attachment_type = attachment_attributes.dig :metadata, :mime_type

      def attachment_uri = store.url attachment_id

      def attach(io, **) = attacher.assign(io, **)

      def upload(io, **) = attacher.upload(io, **)

      def errors = attacher.errors

      def valid? = errors.empty?

      private

      attr_reader :attacher, :store
    end
  end
end
