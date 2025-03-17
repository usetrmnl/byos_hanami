# frozen_string_literal: true

require "dry/types"
require "versionaire"

module Terminus
  Types = Dry.Types

  # The custom types.
  module Types
    Version = Constructor Versionaire::Version, Versionaire.method(:Version)
  end
end
