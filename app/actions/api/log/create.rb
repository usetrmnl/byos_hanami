# frozen_string_literal: true

require "initable"
require "petail"

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

          include Initable[problem: Petail]

          using Refines::Actions::Response

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

          def handle request, response
            parameters = request.params
            device = device_repository.find_by_mac_address request.get_header("HTTP_ID")

            return not_found response unless device
            return unprocessable_entity parameters, response unless parameters.valid?

            save device, parameters, response
          end

          private

          def save device, parameters, response
            transformer.call(parameters.to_h).each do |attributes|
              log_repository.create attributes.merge!(device_id: device.id)
            end

            response.status = 204
          end

          def not_found response
            body = problem[
              type: "/problem_details#device_id",
              status: __method__,
              detail: "Invalid device ID.",
              instance: "/api/log"
            ]

            logger.error "Unable to find device."
            response.with body: body.to_json, format: :problem_details, status: 404
          end

          def unprocessable_entity parameters, response
            errors = parameters.errors.to_h

            body = problem[
              type: "/problem_details#log_payload",
              status: __method__,
              detail: "Validation failed due to incorrect or invalid payload.",
              instance: "/api/log",
              extensions: errors
            ]

            logger.error errors
            response.with body: body.to_json, format: :problem_details, status: 422
          end
        end
      end
    end
  end
end
