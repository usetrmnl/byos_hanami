# frozen_string_literal: true

require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Parsers
        # Parses text into a data hash.
        Text = lambda do |body|
          Dry::Monads::Success({"data" => String(body).split})
        rescue ArgumentError => error
          Dry::Monads::Failure "#{error.message.capitalize}."
        end
      end
    end
  end
end
