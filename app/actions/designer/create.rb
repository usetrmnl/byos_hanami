# frozen_string_literal: true

module Terminus
  module Actions
    module Designer
      # The create action.
      class Create < Terminus::Action
        include Deps[
          :htmx,
          screen_creator: "aspects.screens.creator",
          show_view: "views.designer.show"
        ]

        params do
          required(:template).filled(:hash) do
            required(:id).filled :integer
            required(:content).filled :string
          end
        end

        def handle request, response
          parameters = request.params

          halt 422 unless parameters.valid?

          if htmx.request(**request.env).request?
            render_text parameters[:template], response
          else
            response.render show_view, id: Time.new.utc.to_i
          end
        end

        private

        def render_text template, response
          id, content = template.values_at :id, :content

          creator.call(settings.previews_root.mkpath.join("#{id}.png"), content:)

          response.body = content.strip
          response.status = 201
        end
      end
    end
  end
end
