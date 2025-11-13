# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The delete action.
      class Delete < Terminus::Action
        include Deps[repository: "repositories.device"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_content unless parameters.valid?

          repository.delete parameters[:id]
          response.body = ""
        end
      end
    end
  end
end
