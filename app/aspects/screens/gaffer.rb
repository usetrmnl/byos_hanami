# frozen_string_literal: true

module Terminus
  module Aspects
    module Screens
      # Creates error with problem details for device.
      class Gaffer
        include Deps[
          "aspects.screens.creator",
          repository: "repositories.screen",
          view: "views.gaffe.new"
        ]

        def call device, problem
          id = device.friendly_id

          creator.call model_id: device.model_id,
                       name: "terminus_error_#{id.downcase}",
                       label: "Error #{id}",
                       content: String.new(view.call(problem:))
        end
      end
    end
  end
end
