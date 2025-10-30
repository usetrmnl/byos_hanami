# frozen_string_literal: true

require "dry/monads"
require "nori"

module Terminus
  module Aspects
    module Extensions
      module Parsers
        # Parses XML into a hash.
        XML = lambda do |body, parser: Nori.new(parser: :rexml)|
          content = parser.parse String(body)
          Dry::Monads::Success content.empty? ? {"data" => content} : content
        rescue REXML::ParseException => error
          Dry::Monads::Failure error.message
        end
      end
    end
  end
end
