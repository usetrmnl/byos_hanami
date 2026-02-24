# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Actions
    module Extensions
      module Poll
        # The show action.
        class Show < Action
          include Deps[
            repository: "repositories.extension",
            fetcher: "aspects.extensions.multi_fetcher"
          ]
          include Initable[json_formatter: Aspects::JSONFormatter]

          using Refinements::Hash

          params { required(:extension_id).filled :integer }

          def handle request, response
            extension = repository.find request.params[:extension_id]

            halt :not_found unless extension

            render extension, response
          end

          private

          def render extension, response
            case fetcher.call extension
              in Success(content:, errors:)
                response.render view, content: sanitize(extension, content), layout: false
              in Failure(content:, errors:)
                response.render view, content:, errors:, layout: false
              # :nocov:
              # :nocov:
            end
          end

          def sanitize extension, content
            content.transform_values! { "Binary request..." } if extension.kind == "image"
            json_formatter.call content
          end
        end
      end
    end
  end
end
