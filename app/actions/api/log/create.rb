# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Log
        # The create action.
        class Create < Terminus::Action
          include Deps[
            :logger,
            transformer: "aspects.api.transformers.firmware_log",
            device_repository: "repositories.device",
            log_repository: "repositories.device_log"
          ]

          format :json

          params do
            required(:log).hash do
              required(:logs_array).array(:hash) do
                required(:device_status_stamp).filled(:hash) do
                  required(:battery_voltage).filled :float
                  required(:current_fw_version).filled :string
                  required(:free_heap_size).filled :integer
                  required(:max_alloc_size).filled :integer
                  required(:refresh_rate).filled :integer
                  required(:special_function).filled :string
                  required(:time_since_last_sleep_start).filled :integer
                  required(:wakeup_reason).filled :string
                  required(:wifi_rssi_level).filled :integer
                  required(:wifi_status).filled :string
                end
                optional(:additional_info).maybe(:hash) do
                  optional(:retry_attempt).filled :integer
                end
                required(:creation_timestamp).filled :integer
                required(:log_id).filled :integer
                required(:log_message).filled :string
                required(:log_codeline).filled :integer
                required(:log_sourcefile).filled :string
              end
            end
          end

          # :reek:FeatureEnvy
          def handle request, response
            environment = request.env
            parameters = request.params

            save environment, parameters

            response.status = 204
          end

          private

          def save environment, parameters
            if parameters.valid?
              device = device_repository.find_by_mac_address environment["HTTP_ID"]

              transformer.call(parameters.to_h).each do |attributes|
                log_repository.create attributes.merge!(device_id: device.id)
              end
            else
              logger.error parameters.errors
            end
          end
        end
      end
    end
  end
end
