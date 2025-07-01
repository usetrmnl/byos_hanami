# frozen_string_literal: true

module Terminus
  module Actions
    module Playlists
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          repository: "repositories.playlist",
          new_view: "views.playlists.new",
          index_view: "views.playlists.index"
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
          settings[:layout] = false if htmx.request(**request.env).request?
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
