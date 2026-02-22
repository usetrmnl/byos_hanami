# auto_register: false
# frozen_string_literal: true

require "initable"

module Terminus
  module Jobs
    module Batches
      # Enqueues a job for each model ID.
      class Extension < Base
        include Deps[repository: "repositories.extension"]
        include Initable[job: Jobs::Extensions::Screen]

        sidekiq_options queue: "within_1_minute"

        def perform id
          extension = repository.find id

          return Failure "Unable to enqueue jobs for extension: #{id}." unless extension

          extension.devices.any? ? enqueue_devices(extension) : enqueue_models(extension)

          Success "Enqueued jobs for extension: #{id}."
        end

        private

        def enqueue_models extension
          extension.models.each { |model| job.perform_async extension.id, model.id }
        end

        def enqueue_devices extension
          extension.devices.each { |device| job.perform_async extension.id, nil, device.id }
        end
      end
    end
  end
end
