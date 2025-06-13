# frozen_string_literal: true

module Terminus
  module Actions
    module Firmware
      # The delete action.
      class Delete < Terminus::Action
        include Deps[repository: "repositories.firmware"]

        using Refines::Actions::Response

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          repository.delete parameters[:id]
          response.with body: "", status: 200
        end
      end
    end
  end
end
