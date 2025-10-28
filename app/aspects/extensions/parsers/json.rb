# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Parsers
        # Parses JSON into a data hash.
        JSON = lambda do |body|
          return Dry::Monads::Success({"data" => []}) if String(body).empty?

          content = JSON(body).then { it.is_a?(Hash) ? it : {"data" => it} }
          Dry::Monads::Success content
        rescue ::JSON::ParserError => error
          Dry::Monads::Failure "#{error.message.capitalize}."
        end
      end
    end
  end
end
