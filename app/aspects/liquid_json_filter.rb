# auto_register: false
# frozen_string_literal: true

require "json"

module Terminus
  module Aspects
    # A JSON filter for liquid templates
    module LiquidJSONFilter
      def json data
        data.to_json
      end
    end
  end
end
