# frozen_string_literal: true

require "infusible"

module Terminus
  # Defines endpoint dependencies for automatic injection.
  module Endpoints
    Dependencies = Infusible[Container]
  end
end
