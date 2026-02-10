# frozen_string_literal: true

module Terminus
  module Contracts
    module Models
      # The contract for model updates.
      class Update < Contract
        config.messages.namespace = :model

        params do
          required(:id).filled :integer
          required(:model).filled Schemas::Models::Upsert
        end
      end
    end
  end
end
