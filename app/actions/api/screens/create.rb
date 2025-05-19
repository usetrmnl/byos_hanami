# frozen_string_literal: true

require "dry/monads"
require "initable"
require "refinements/pathname"

module Terminus
  module Actions
    module API
      module Screens
        # The create action.
        class Create < Terminus::Action
          include Deps[:settings, repository: "repositories.device"]
          include Initable[creator: proc { Terminus::Screens::Creator.new }]
          include Dry::Monads[:result]

          using Refinements::Pathname
          using Refines::Actions::Response

          format :json

          params do
            required(:image).hash do
              required(:content).filled :string
              optional(:file_name).filled :string
            end
          end

          def handle request, response
            parameters = request.params
            device = repository.find_by_api_key request.env["HTTP_ACCESS_TOKEN"]

            if parameters.valid? && device
              save device, parameters[:image], response
            else
              response.with body: parameters.errors.to_json, status: 400
            end
          end

          private

          # :nocov:
          # :reek:FeatureEnvy
          def save device, image, response
            case creator.call image[:content], output_path(device.slug, image)
              in Success(path) then response.with body: {path:}.to_json, status: 200
              in Failure(error) then response.with body: {error:}.to_json, status: 400
              else response.with body: {error: "Unknown error."}.to_json, status: 500
            end
          end

          def output_path slug, image
            settings.screens_root.join(slug).mkpath.join image.fetch(:file_name, "%<name>s.png")
          end
        end
      end
    end
  end
end
