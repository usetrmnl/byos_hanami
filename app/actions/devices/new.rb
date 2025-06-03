# frozen_string_literal: true

module Terminus
  module Actions
    module Devices
      # The new action.
      class New < Terminus::Action
        include Deps["aspects.devices.builder"]

        def handle request, response
          view_settings = {}
          view_settings[:layout] = false if request.env.key? "HTTP_HX_REQUEST"

          response.render view, **view_settings, fields: builder.call
        end
      end
    end
  end
end
