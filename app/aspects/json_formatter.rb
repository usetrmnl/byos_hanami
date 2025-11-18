# auto_register: false
# frozen_string_literal: true

require "functionable"
require "json"

module Terminus
  module Aspects
    # A simple JSON pretty printer.
    module JSONFormatter
      extend Functionable

      def call(data) = JSON data, indent: "  ", space: " ", object_nl: "\n", array_nl: "\n"
    end
  end
end
