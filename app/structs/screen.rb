# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Structs
    # The screen struct.
    class Screen < DB::Struct
      include Terminus::Uploaders::Image::Attachment[:attachment]

      using Refinements::Hash

      attr_accessor :attachment_data

      def attachment_attributes = attributes[:attachment].deep_symbolize_keys

      def attach(io, **) = attachment_attacher.assign(io, **)

      def upload(io, **)
        attach(io, **)
        return attachment_attacher if attachment_attacher.errors.any?

        attachment_attacher.tap(&:finalize)
      end

      def valid_attachment? = attachment_attacher.errors.empty?
    end
  end
end
