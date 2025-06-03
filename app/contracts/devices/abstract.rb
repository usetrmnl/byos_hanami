# frozen_string_literal: true

module Terminus
  module Contracts
    module Devices
      # The abstract contract for device create and update.
      class Abstract < Dry::Validation::Contract
        rule device: :sleep_start_at do
          end_at = values.dig :device, :sleep_end_at

          if value && end_at && value > end_at then key.failure "must be before end time"
          elsif value && end_at.nil? then key.failure "must have corresponding end time"
          elsif value.nil? && end_at then key.failure "must be filled"
          else next
          end
        end

        rule device: :sleep_end_at do
          start_at = values.dig :device, :sleep_start_at

          if value && start_at && value < start_at then key.failure "must be after start time"
          elsif value && start_at.nil? then key.failure "must have corresponding start time"
          elsif value.nil? && start_at then key.failure "must be filled"
          else next
          end
        end
      end
    end
  end
end
