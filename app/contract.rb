# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  # Defines user create contract.
  class Contract < Dry::Validation::Contract
    using Refinements::Pathname

    config.messages.backend = :i18n
    config.messages.load_paths.merge Hanami.app.root.join("config/locales").files("*.yml")
  end
end
