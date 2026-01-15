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

            load(parameters).either -> payload { render request, payload, response },
                                    -> message { render_error parameters, message, response }
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

          def render request, payload, response
            query = request.params[:query]

            if htmx.request(**request.env).request?
              add_htmx_headers response, query
              response.render view, payload:, query:, layout: false
            else
              response.render view, payload:, query:
            end
          end

          def add_htmx_headers response, query
            return if String(query).empty?

            htmx.response! response.headers, push_url: routes.path(:extensions_gallery, query:)
          end

          # rubocop:todo Metrics/MethodLength
          def render_error parameters, message, response
            response.flash.now[:alert] = message

            payload = TRMNL::API::Models::Recipe[
              data: [],
              total: 0,
              from: 0,
              to: 0,
              per_page: 0,
              current_page: 0,
              prev_page_url: nil,
              next_page_url: nil
            ]

            response.render view, payload:, query: parameters[:query]
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
