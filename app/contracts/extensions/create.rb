# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      # The contract for extension creation.
      class Create < Dry::Validation::Contract
        params do
          required(:extension).filled Schemas::Extensions::Upsert
          optional(:model_ids).filled :array
        end
      end
    end
  end
end
