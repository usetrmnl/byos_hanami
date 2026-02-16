# auto_register: false
# frozen_string_literal: true

require "csv"
require "dry/core"
require "dry/monads"
require "functionable"
require "json"
require "nori"

module Terminus
  module Aspects
    module Extensions
      # Parses supported data types into a hash for further processing.
      module Parser
        extend Dry::Monads[:result]
        extend Functionable

        def from_csv body
          Success({"source" => Success(::CSV.parse(String(body), headers: true).each.map(&:to_h))})
        rescue ::CSV::MalformedCSVError => error
          Failure error.message
        end

        def from_image(body) = Success "source" => Success(body)

        def from_json body
          return Success({"source" => Success(Dry::Core::EMPTY_ARRAY)}) if String(body).empty?

          content = JSON(body).then { {"source" => Success(it)} }
          Success content
        rescue ::JSON::ParserError => error
          Failure "#{error.message.capitalize}."
        end

        def from_text body
          Success({"source" => Success(String(body).split)})
        rescue ArgumentError => error
          Failure "#{error.message.capitalize}."
        end

        def from_xml body, nori: Nori.new(parser: :rexml)
          content = nori.parse String(body)
          Success({"source" => Success(content)})
        rescue REXML::ParseException => error
          Failure error.message
        end
      end
    end
  end
end
