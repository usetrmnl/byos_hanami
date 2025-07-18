# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      module Items
        # The create action.
        class Create < Terminus::Action
          include Deps[
            repository: "repositories.playlist_item",
            new_view: "views.playlists.items.new",
            index_view: "views.playlists.items.index"
          ]

          params do
            required(:playlist).hash do
              required(:label).filled :string
              required(:name).filled :string
            end
          end

          def handle request, response
            parameters = request.params

            if parameters.valid?
              repository.create parameters[:playlist]
              response.render index_view, **view_settings(request, parameters)
            else
              render_new response, parameters
            end
          end

          private

          def view_settings request, _parameters
            settings = {playlists: repository.all}

            settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"
            settings
          end

          # :reek:FeatureEnvy
          def render_new response, parameters
            response.render new_view,
                            playlist: nil,
                            fields: parameters[:playlist],
                            errors: parameters.errors[:playlist],
                            layout: false
          end
        end
      end
    end
  end
end
