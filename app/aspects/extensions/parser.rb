# auto_register: false
# frozen_string_literal: true

require "csv"
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
          Success({"data" => ::CSV.parse(String(body), headers: true).each.map(&:to_h)})
        rescue ::CSV::MalformedCSVError => error
          Failure error.message
        end

        def from_json body
          return Success({"data" => []}) if String(body).empty?

          content = JSON(body).then { it.is_a?(Hash) ? it : {"data" => it} }
          Success content
        rescue ::JSON::ParserError => error
          Failure "#{error.message.capitalize}."
        end

        def from_text body
          Success({"data" => String(body).split})
        rescue ArgumentError => error
          Failure "#{error.message.capitalize}."
        end

        def from_xml body, nori: Nori.new(parser: :rexml)
          content = nori.parse String(body)
          Success content.empty? ? {"data" => content} : content
        rescue REXML::ParseException => error
          Failure error.message
        end
      end
    end
  end
end
