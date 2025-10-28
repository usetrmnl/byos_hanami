# frozen_string_literal: true

require "csv"
require "dry/monads"

module Terminus
  module Aspects
    module Extensions
      module Parsers
        # Parses CSV data into a data hash.
        CSV = lambda do |body|
          Dry::Monads::Success(
            {"data" => ::CSV.parse(String(body), headers: true).each.map(&:to_h)}
          )
        rescue ::CSV::MalformedCSVError => error
          Dry::Monads::Failure error.message
        end
      end
    end
  end
end
