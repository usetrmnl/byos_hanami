# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      module Info
        # The show action.
        class Show < Terminus::Action
          include Deps[repository: "repositories.device"]

          params { required(:id).filled :integer }

          def handle request, response
            parameters = request.params
            halt :unprocessable_entity unless parameters.valid?
            response.render view, device: repository.find(parameters[:id]), layout: false
          end
        end
      end
    end
  end
end
