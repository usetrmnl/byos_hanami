# frozen_string_literal: true

module Terminus
  module Actions
    module Screens
      # The new action.
      class New < Terminus::Action
        def initialize(model_optioner: Aspects::Models::Optioner, **)
          @model_optioner = model_optioner
          super(**)
        end

        def handle request, response
          view_settings = {model_options: model_optioner.call}
          view_settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"

          response.render view, **view_settings
        end

        private

        attr_reader :model_optioner
      end
    end
  end
end
