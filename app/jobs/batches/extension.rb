# auto_register: false
# frozen_string_literal: true

require "initable"

module Terminus
  module Jobs
    module Batches
      # Enqueues a job for each model ID.
      class Extension < Base
        include Deps[repository: "repositories.extension"]
        include Initable[job: Jobs::ExtensionScreen]

        sidekiq_options queue: "within_1_minute"

        def perform id
          extension = repository.find id

          return Failure "Unable to enqueue jobs for extension: #{id}." unless extension

          extension.models.each { |model| job.perform_async extension.id, model.id }
          Success "Enqueued jobs for extension: #{id}."
        end
      end
    end
  end
end
