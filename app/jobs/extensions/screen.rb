# auto_register: false
# frozen_string_literal: true

module Terminus
  module Jobs
    module Extensions
      # Creates screen for extension and model or device ID.
      class Screen < Base
        include Deps["aspects.extensions.screen_upserter", repository: "repositories.extension"]

        sidekiq_options queue: "within_1_minute"

        def perform id, model_id = nil, device_id = nil
          extension = repository.find id

          return Failure "Unable to find by extension ID: #{id}." unless extension

          screen_upserter.call extension, model_id:, device_id:
        end
      end
    end
  end
end
