# frozen_string_literal: true

module Terminus
  module Contracts
    module Models
      # The contract for model creation.
      class Create < Contract
        config.messages.namespace = :model

        params { required(:model).filled Schemas::Models::Upsert }
      end
    end
  end
end
