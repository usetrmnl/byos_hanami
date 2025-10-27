# frozen_string_literal: true

require "refinements/array"
require "sanitize"

module Terminus
  module Aspects
    # A custom HTML sanitizer.
    class Sanitizer
      using Refinements::Array

      def initialize defaults: Sanitize::Config::RELAXED, client: Sanitize
        @defaults = defaults
        @client = client
      end

      def call(content) = client.document content, configuration

      private

      attr_reader :defaults, :client

      def configuration = client::Config.merge(defaults, elements:, attributes:)

      def elements = defaults[:elements].including "html", "link", "script", "source", "style"

      def attributes
        defaults[:attributes].merge "div" => [:data],
                                    "link" => %w[href rel],
                                    "script" => %w[src],
                                    "source" => %w[type src srcset sizes media height width]
      end
    end
  end
end
