# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The edit action.
      class Edit < Terminus::Action
        include Deps[repository: "repositories.device"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          response.render view, **view_settings(request, parameters)
        end

        private

        def view_settings request, parameters
          settings = {device: repository.find(parameters[:id])}

          settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
          settings
        end
      end
    end
  end
end
