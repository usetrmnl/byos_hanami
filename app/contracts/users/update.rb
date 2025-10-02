# frozen_string_literal: true

module Terminus
  module Contracts
    module Users
      # Defines user update contract.
      class Update < Dry::Validation::Contract
        params do
          required(:id).filled :integer

          required(:user).filled(:hash) do
            required(:name).filled :string
            required(:email).filled :string
            optional(:password).maybe(:string, min_size?: 10)
            required(:status_id).filled :integer
          end
        end
      end
    end
  end
end
