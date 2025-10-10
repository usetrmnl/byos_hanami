# frozen_string_literal: true

require "dry/core"
require "htmx"
require "refinements/hash"

module Terminus
  module Views
    # The view helpers.
    module Helpers
      extend Hanami::View::Helpers::TagHelper

      using Refinements::Hash

      module_function

      def boolean value
        css_class = value == true ? "bit-text-green" : "bit-text-red"
        tag.span value.to_s, class: css_class
      end

      def field_for key, attributes, record = nil
        return attributes[key] unless record

        value = attributes.fetch_value key, record.public_send(key)

        case value
          when Sequel::SQLTime then value.strftime("%H:%M:%S")
          when Time then value.strftime("%Y-%m-%dT%H:%M")
          else value
        end
      end

      def git_sha_link
        sha = Hanami.app[:settings].git_sha
        link_to sha, "https://github.com/usetrmnl/byos_hanami/commit/#{sha}", class: :link
      end

      def git_tag_link
        tag = Hanami.app[:settings].git_tag
        link_to tag, "https://github.com/usetrmnl/byos_hanami/releases/tag/#{tag}", class: :link
      end

      def human_at(value) = (value.strftime "%B %d %Y at %H:%M %Z" if value)

      def human_time(value) = (value.strftime "%I:%M %p" if value)

      def select_options_for records, label: :label, id: :id
        records.reduce [["Select...", Dry::Core::EMPTY_STRING]] do |options, record|
          options.append [record.public_send(label), record.public_send(id)]
        end
      end

      def size value, kilobyte: 1_024, units: %w[B KB MB GB TB]
        bytes = value.to_f
        index = 0

        while bytes >= kilobyte && index < units.length - 1
          bytes /= kilobyte
          index += 1
        end

        "#{bytes.round 2} #{units[index]}"
      end
    end
  end
end
