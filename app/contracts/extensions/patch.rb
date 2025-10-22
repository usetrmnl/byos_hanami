# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      # The contract for extension patches.
      class Patch < Dry::Validation::Contract
        params do
          required(:id).filled :integer

          required(:extension).filled(:hash) do
            optional(:name).filled :string
            optional(:label).filled :string
            optional(:description).maybe :string
            optional(:kind).filled :string
            optional(:mode).filled :string
            optional(:tags).array :string
            optional(:headers).maybe :hash
            optional(:verb).filled :string
            optional(:uri).maybe :string
            optional(:body).maybe :hash
            optional(:fields).maybe :hash
            optional(:template).maybe :string
            optional(:globals).maybe :hash
            optional(:repeat_interval).filled { int? > gteq?(0) }
            optional(:repeat_type).filled :string
            optional(:repeat_days).array :string
            optional(:last_day_of_month).filled :bool
          end
        end
      end
    end
  end
end
