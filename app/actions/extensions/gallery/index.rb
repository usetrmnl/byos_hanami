# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      module Gallery
        # The index action.
        class Index < Action
          include Deps[:htmx, trmnl_api: :trmnl_api_recipes]

          params do
            optional(:query).filled :string
            optional(:page).filled :integer
          end

          def handle request, response
            parameters = request.params
            query = parameters[:query]

            load(parameters).either -> payload { render request, payload, query, response },
                                    -> message { response.flash.now[:alert] = message }
          end

          private

          def load parameters
            case parameters
              in query:, page: then trmnl_api.recipes(search: query, page:)
              in query: then trmnl_api.recipes search: query
              in page: then trmnl_api.recipes(page:)
              else trmnl_api.recipes
            end
          end

          # rubocop:todo Metrics/ParameterLists
          def render request, payload, query, response
            if htmx.request(**request.env).request?
              add_htmx_headers response, query
              response.render view, payload:, query:, layout: false
            else
              response.render view, payload:, query:
            end
          end
          # rubocop:enable Metrics/ParameterLists

          def add_htmx_headers response, query
            return if String(query).empty?

            htmx.response! response.headers, push_url: routes.path(:extensions_gallery, query:)
          end
        end
      end
    end
  end
end
