# frozen_string_literal: true

require "initable"
require "liquid"

module Terminus
  module Actions
    module Extensions
      module Preview
        # The show action.
        class Show < Terminus::Action
          include Deps[repository: "repositories.extension", view: "views.extensions.dynamic"]
          include Dependencies[:http]
          include Initable[parser: Liquid::Template]

          params { required(:id).filled :integer }

          # :reek:TooManyStatements
          def handle request, response
            parameters = request.params

            halt :unprocessable_entity unless parameters.valid?

            extension = repository.find parameters[:id]

            halt :not_found unless extension

            template = parser.parse extension.template_full

            response.render view, body: body(extension, template)
          end

          private

          # :reek:FeatureEnvy
          # :reek:TooManyStatements
          # rubocop:todo Metrics/MethodLength
          def body extension, template
            uri = extension.uris.first

            case extension.kind
              when "image" then template.render("image_uri" => uri)
              when "poll"
                http.use(:auto_inflate)
                    .headers(extension.headers)
                    .get(uri)
                    .then { |response| template.render response.parse }

              when "static" then template.render extension.static_body
              else "Unsupported."
            end
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
