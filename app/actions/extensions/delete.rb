# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The delete action.
      class Delete < Terminus::Action
        include Deps[repository: "repositories.extension"]

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
