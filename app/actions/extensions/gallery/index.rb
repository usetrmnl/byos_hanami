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

            load(parameters).either -> recipe { render request, recipe, response },
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

          def render request, recipe, response
            query, page = request.params.to_h.values_at :query, :page

            if htmx.request(**request.env).request?
              add_htmx_headers response, query, page
              response.render view, recipe:, query:, page:, layout: false
            else
              response.render view, recipe:, query:, page:
            end
          end

          def add_htmx_headers response, query, page
            return if String(query).empty?

            htmx.response! response.headers,
                           push_url: routes.path(:extensions_gallery, query:, page:)
          end

          def render_error parameters, message, response
            response.flash.now[:alert] = message

            recipe = TRMNL::API::Models::Recipe[
              data: [],
              meta: TRMNL::API::Models::Recipes::Meta.new
            ]

            response.render view, recipe:, query: parameters[:query]
          end
        end
      end
    end
  end
end
