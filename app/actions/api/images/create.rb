# frozen_string_literal: true

require "initable"
require "refinements/pathname"

module Terminus
  module Actions
    module API
      module Images
        # The create action.
        class Create < Terminus::Action
          include Deps[:settings]
          include Initable[creator: proc { Terminus::Screens::Creator.new }]

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

            if parameters.valid?
              image = parameters[:image]
              path = creator.call image[:content], output_path(image)
              response.with body: {path:}.to_json, status: 200
            else
              response.with body: parameters.errors.to_json, status: 400
            end
          end

          private

          def output_path image
            Pathname(settings.generated_root).mkpath
                                             .join %(#{image.fetch :file_name, "%<name>s"}.bmp)
          end
        end
      end
    end
  end
end
