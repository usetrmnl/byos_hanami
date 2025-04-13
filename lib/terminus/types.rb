# frozen_string_literal: true

require "dry/types"
require "pathname"
require "versionaire"

module Terminus
  # The custom types.
  module Types
    include Dry.Types(default: :strict)

    Pathname = Constructor ::Pathname
    Version = Constructor Versionaire::Version, Versionaire.method(:Version)
  end
end
