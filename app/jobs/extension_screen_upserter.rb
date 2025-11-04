# auto_register: false
# frozen_string_literal: true

require "dry/monads"
require "sidekiq"

module Terminus
  module Jobs
    # Asynchronously creates screen for extension and model.
    class ExtensionScreenUpserter
      include Sidekiq::Job
      include Deps[
        :logger,
        upserter: "aspects.extensions.screen_upserter",
        repository: "repositories.extension"
      ]
      include Dry::Monads[:result]

      def perform id, model_id
        extension = repository.find id

        return Failure "Unable to find by extension ID: #{id}." unless extension

        upserter.call extension, model_id
      end
    end
  end
end
