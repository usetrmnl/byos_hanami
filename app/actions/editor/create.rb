# frozen_string_literal: true

module Terminus
  module Actions
    module Editor
      # The create action.
      class Create < Terminus::Action
        include Deps[:settings, show_view: "views.editor.show"]
        include Initable[creator: proc { Terminus::Screens::Creator.new }]

        params do
          required(:template).hash do
            required(:id).filled :integer
            required(:content).filled :string
          end
        end

        def handle request, response
          parameters = request.params

          halt 422 unless parameters.valid?

          if request.env.key? "HTTP_HX_REQUEST"
            render_text parameters[:template], response
          else
            response.render show_view, id: Time.new.to_i
          end
        end

        private

        def render_text template, response
          id, content = template.values_at :id, :content

          creator.call content, settings.previews_root.mkpath.join("#{id}.bmp")

          response.body = content.strip
          response.status = 201
        end
      end
    end
  end
end
