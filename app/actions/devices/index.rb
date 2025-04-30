# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The index action.
      class Index < Terminus::Action
        include Deps[repository: "repositories.device"]

        params { optional(:query).filled :string }

        def handle request, response
          query = request.params[:query]

          if request.get_header("HTTP_HX_TRIGGER") == "search"
            add_htmx_headers response, query
            response.render view, devices: repository.find_all_by_label(query), layout: false
          else
            response.render view, devices: repository.all
          end
        end

        private

        def add_htmx_headers response, query
          return unless query

          response.headers["HX-Push-Url"] = routes.path :devices, query:
        end
      end
    end
  end
end
