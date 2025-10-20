# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      # The contract for extension updates.
      class Update < Dry::Validation::Contract
        params do
          required(:id).filled :integer
          required(:extension).filled Schemas::Extensions::Upsert
          optional(:model_ids).filled :array
        end
      end
    end
  end
end
