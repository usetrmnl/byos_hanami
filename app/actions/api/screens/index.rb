# frozen_string_literal: true

require "refinements/pathname"

module Terminus
  module Actions
    module API
      module Screens
        # The index action.
        class Index < Base
          include Deps[:settings, device_repository: "repositories.device"]

          using Refinements::Pathname

          def handle request, response
            device = device_repository.find_by api_key: request.env["HTTP_ACCESS_TOKEN"]

            response.body = if device
                              {data: build_records(device)}.to_json
                            else
                              {data: []}.to_json
                            end
          end

          private

          def build_records device
            root = settings.screens_root

            root.join(device.slug)
                .files
                .reduce([]) do |all, path|
                  relative_path = path.relative_path_from config.root_directory
                  all.append({name: path.basename, path: "#{settings.api_uri}/#{relative_path}"})
                end
          end
        end
      end
    end
  end
end
