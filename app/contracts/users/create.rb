# frozen_string_literal: true

module Terminus
  module Contracts
    module Users
      # Defines user create contract.
      class Create < Dry::Validation::Contract
        params do
          required(:user).filled(:hash) do
            required(:name).filled :string
            required(:email).filled :string
            optional(:password).maybe(:string, min_size?: 10)
            optional(:status_id).filled :integer
          end

          optional(:account).filled(:hash) do
            required(:name).filled :string
            required(:label).filled :string
          end
        end
      end
    end
  end
end
