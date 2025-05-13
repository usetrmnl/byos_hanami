# frozen_string_literal: true

module Terminus
  module Actions
    module Firmware
      # The index action.
      class Index < Terminus::Action
        include Deps["aspects.firmware.fetcher"]

        def handle request, response
          query = request.params[:query]
          firmware = load query

          if request.get_header("HTTP_HX_TRIGGER") == "search"
            add_htmx_headers response, query
            response.render view, firmware:, query:, layout: false
          else
            response.render view, firmware:, query:
          end
        end

        private

        def load query
          paths = fetcher.call

          return paths unless query

          paths.select { |firmware| firmware.version.match? query }
        end

        def add_htmx_headers response, query
          response.headers["HX-Push-Url"] = routes.path :firmware, query:
        end
      end
    end
  end
end
