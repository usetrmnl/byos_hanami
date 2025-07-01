# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      # The delete action.
      class Delete < Terminus::Action
        include Deps[repository: "repositories.playlist", index_view: "views.playlists.index"]

        params { required(:id).filled :integer }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          repository.delete parameters[:id]

          response.render index_view, playlists: repository.all, layout: false
        end
      end
    end
  end
end
