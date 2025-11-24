# auto_register: false
# frozen_string_literal: true

module Terminus
  module Jobs
    # Creates screen for extension and model.
    class ExtensionScreen < Base
      include Deps["aspects.extensions.screen_upserter", repository: "repositories.extension"]

      sidekiq_options queue: "within_1_minute"

      def perform id, model_id
        extension = repository.find id

        return Failure "Unable to find by extension ID: #{id}." unless extension

        screen_upserter.call extension, model_id
      end
    end
  end
end
