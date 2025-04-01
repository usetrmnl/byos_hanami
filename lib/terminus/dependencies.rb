# frozen_string_literal: true

require "infusible"

module Terminus
  # Defines application dependencies for automatic injection.
  Dependencies = Infusible[LibContainer]
end
