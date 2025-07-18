# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The update action.
        class Update < Terminus::Action
          include Deps[
            repository: "repositories.playlist_item",
            show_view: "views.playlists.items.show",
            edit_view: "views.playlists.items.edit"
          ]

          params do
            required(:id).filled :integer
            required(:playlist_id).filled :integer
            required(:playlist_item).hash { required(:screen_id).filled :integer }
          end

          def handle request, response
            parameters = request.params

            if parameters.valid?
              save parameters, response
            else
              edit parameters, response
            end
          end

          private

          def save parameters, response
            item = repository.find_by playlist_id: parameters[:playlist_id], id: parameters[:id]
            id = item.id
            repository.update id, **parameters[:playlist_item]

            # FIX: Ensure updated record includes associations so you don't have to find record.
            response.render show_view, item: repository.find(id), layout: false
          end

          # :reek:FeatureEnvy
          def edit parameters, response
            response.render edit_view,
                            playlist:,
                            fields: parameters[:playlist],
                            errors: parameters.errors[:playlist],
                            layout: false
          end
        end
      end
    end
  end
end
