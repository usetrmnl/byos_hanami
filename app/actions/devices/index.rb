# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The index action.
      class Index < Terminus::Action
        include Deps[repository: "repositories.device"]

        def handle request, response
          response.render view, **view_settings(request)
        end

        private

        def view_settings request
          settings = {devices: repository.all}

          settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
          settings
        end
      end
    end
  end
end
