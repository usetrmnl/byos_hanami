# frozen_string_literal: true

module Terminus
  module Contracts
    module Extensions
      # The contract for extension updates.
      class Update < Contract
        config.messages.namespace = :extension

        params do
          required(:id).filled :integer
          required(:extension).filled Schemas::Extensions::Upsert
          optional(:model_ids).array :int?
          optional(:device_ids).array :int?
        end

        rule extension: :interval, &Rules::Cron
      end
    end
  end
end
