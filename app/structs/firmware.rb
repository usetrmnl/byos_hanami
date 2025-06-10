# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Structs
    # The firmware struct.
    class Firmware < DB::Struct
      include Terminus::Uploaders::Binary::Attachment[:attachment]

      using Refinements::Hash

      attr_accessor :attachment_data

      def attachment_attributes = attributes[:attachment].deep_symbolize_keys

      def attachment_id = attachment_attributes[:id]

      def attachment_uri = store.url attachment_id

      def attach(io, **) = attachment_attacher.assign(io, **)

      def upload(io, **)
        attach(io, **)
        return attachment_attacher if attachment_attacher.errors.any?

        attachment_attacher.tap(&:finalize)
      end

      def valid_attachment? = attachment_attacher.errors.empty?

      def file_name = attachment_attributes.dig :metadata, :filename

      def file_size = attachment_attributes.dig :metadata, :size

      def mime_type = attachment_attributes.dig :metadata, __method__

      private

      def store = @store ||= Shrine.storages[:store]
    end
  end
end
