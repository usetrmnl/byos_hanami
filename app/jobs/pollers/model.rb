# auto_register: false
# frozen_string_literal: true

module Terminus
  module Jobs
    module Pollers
      # Polls TRMNL API for model changes.
      class Model < Base
        include Deps[:settings, :logger, "aspects.models.synchronizer"]

        sidekiq_options queue: "within_1_minute"

        def perform
          return synchronizer.call if settings.model_poller

          logger.info { "Model polling disabled." }
        end
      end
    end
  end
end
