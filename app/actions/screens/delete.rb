# frozen_string_literal: true

module Terminus
  module Actions
    module Screens
      # The delete action.
      class Delete < Terminus::Action
        include Deps[repository: "repositories.screen", index_view: "views.screens.index"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          repository.delete parameters[:id]

          response.render index_view, screens: repository.all, layout: false
        end
      end
    end
  end
end
