# frozen_string_literal: true

require "securerandom"

module Terminus
  module Screens
    Randomizer = proc { SecureRandom.uuid }
  end
end
