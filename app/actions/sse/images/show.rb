# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module SSE
      module Images
        # The show action.
        class Show < Terminus::Action
          include Deps[:settings, repository: "repositories.device"]

          include Initable[fetcher: proc { Terminus::Images::Fetcher.new }]

          using Refines::Actions::Response

          params { required(:id).filled :integer }

          format :txt

          # :reek:DuplicateMethodCall
          # :reek:TooManyStatements
          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            device = repository.find parameters[:id]

            halt :unprocessable_entity unless device

            response.headers.merge! "Content-Type" => "text/event-stream",
                                    "Cache-Control" => "no-cache",
                                    "Connection" => "keep-alive"

            fetch response
          end

          private

          def fetch response
            loop do
              image = fetcher.call Pathname(settings.images_root).join("generated"),
                                   images_uri: "#{settings.app_url}/assets/images"

              response.body = %(data: <img src="#{image[:image_url]}" alt="Latest Image"/>)

              break if ENV["HANAMI_ENV"] == "test"

              sleep 1
            end
          end
        end
      end
    end
  end
end
