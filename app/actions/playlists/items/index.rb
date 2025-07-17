# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The index action.
        class Index < Hanami::Action
          include Deps[repository: "repositories.playlist_item"]

          def handle *, response
            response.render view, items: repository.all, layout: false
          end
        end
      end
    end
  end
end
