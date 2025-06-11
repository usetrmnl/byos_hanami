# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Structs
    # The screen struct.
    class Screen < DB::Struct
      include Terminus::Uploaders::Image::Attachment[:image]

      using Refinements::Hash

      attr_reader :image_data

      def initialize(*, store: Hanami.app[:shrine].storages[:store])
        super(*)
        @store = store
        @attacher = image_attacher
      end

      def image_attributes = attributes[:image_data].deep_symbolize_keys

      def image_destroy
        store.delete image_id
        attributes[:image_data].clear
      end

      def image_id = image_attributes[:id]

      def attach(io, **) = attacher.assign(io, **)

      def finalize = attacher.tap(&:finalize).file

      def errors = attacher.errors

      def valid? = errors.empty?

      private

      attr_reader :store, :attacher
    end
  end
end
