# frozen_string_literal: true

module Terminus
  module Actions
    module API
      module Screens
        # The delete action.
        class Delete < Base
          include Deps[:settings, device_repository: "repositories.device"]

          def handle request, response
            api_key = request.env["HTTP_ACCESS_TOKEN"]
            device = device_repository.find_by(api_key:)

            response.body = if device
                              {data: build_record(device, request.params[:id])}.to_json
                            else
                              unknown(api_key).to_json
                            end
          end

          private

          # :reek:FeatureEnvy
          def build_record device, id
            path = settings.screens_root.join device.slug, id
            path.delete if path.exist?
            relative_path = path.relative_path_from config.root_directory

            {
              name: path.basename.to_s,
              path: "#{settings.api_uri}/#{relative_path}"
            }
          end

          def unknown api_key
            {
              data: {
                name: "unknown.png",
                path: "#{settings.api_uri}/screens/#{api_key}/unknown.png"
              }
            }
          end
        end
      end
    end
  end
end
