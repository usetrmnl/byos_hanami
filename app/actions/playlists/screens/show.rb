# frozen_string_literal: true

require "refinements/array"

module Terminus
  module Actions
    module Playlists
      module Screens
        # The show action.
        class Show < Hanami::Action
          include Deps[:htmx, repository: "repositories.playlist"]

          using Refinements::Array

          params do
            required(:playlist_id).filled :integer
            required(:id).filled :integer
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_content unless parameters.valid?

            playlist = repository.with_screens.by_pk(parameters[:playlist_id]).one
            response.render view, **view_settings(request, playlist)
          end

          private

          # :reek:FeatureEnvy
          def view_settings request, playlist
            before, current, after = playlist.screens.ring.find do |first, middle, last|
              break first, middle, last if middle.id == request.params[:id]
            end

            view_settings = {}
            view_settings[:layout] = false if htmx.request? request.env, :request, "true"

            view_settings.merge! playlist:, before:, current:, after:
          end
        end
      end
    end
  end
end
