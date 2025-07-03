# frozen_string_literal: true

module Terminus
  module Actions
    module Screens
      # The index action.
      class Index < Hanami::Action
        include Deps[:htmx, repository: "repositories.screen"]

        def handle request, response
          query = request.params[:query].to_s
          screens = load query

          if htmx.request(**request.env).trigger == "search"
            add_htmx_headers response, query
            response.render view, screens:, query:, layout: false
          else
            response.render view, screens:, query:
          end
        end

        private

        def load(query) = query.empty? ? repository.all : repository.all_by(label: query)

        def add_htmx_headers response, query
          return if query.empty?

          response.headers["HX-Push-Url"] = routes.path :screens, query:
        end
      end
    end
  end
end
