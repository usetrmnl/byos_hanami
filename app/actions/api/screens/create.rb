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
              optional(:content).filled :string
              optional(:uri).filled :string
              optional(:data).filled :string
              optional(:file_name).filled :string
              optional(:dimensions).filled :string
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

          def save device, image, response
            result = creator.call(
              {dimensions: "800x480"}.merge(image),
              output_path(device.slug, image)
            )

            if result.success?
              response.with body: {path: result.success}.to_json, status: 200
            else
              response.with body: {error: result.failure}.to_json, status: 400
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
