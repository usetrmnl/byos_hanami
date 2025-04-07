# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  # Makes the oldest file the newest file.
  module Screens
    using Refinements::Pathname

    Toucher = lambda do |root|
      Pathname(root).files.min_by(&:mtime).then { it.touch if it }
    end
  end
end
