# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      # The contract for extension creation.
      class Create < Dry::Validation::Contract
        params { required(:extension).filled Schemas::Extensions::Upsert }
      end
    end
  end
end
