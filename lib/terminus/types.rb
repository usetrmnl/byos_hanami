# frozen_string_literal: true

require "dry/types"
require "pathname"
require "versionaire"

module Terminus
  # The custom types.
  module Types
    include Dry.Types(default: :strict)

    Browser = Types::JSON::Hash.constructor(-> value { JSON value, symbolize_names: true })
                               .schema(
                                 js_errors?: Types::Bool,
                                 process_timeout?: Types::Float,
                                 timeout?: Types::Float
                               )

    Pathname = Constructor ::Pathname

    MACAddress = String.constrained(
      format: /\A[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}\Z/
    )

    Version = Constructor Versionaire::Version, Versionaire.method(:Version)
  end
end
