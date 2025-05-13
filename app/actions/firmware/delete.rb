# frozen_string_literal: true

module Terminus
  module Actions
    module Firmware
      # The delete action.
      class Delete < Terminus::Action
        include Deps[:settings]

        using Refines::Actions::Response

        params { required(:version).filled :string }

        def handle request, response
          parameters = request.params

          halt :unprocessable_entity unless parameters.valid?

          render parameters[:version], response
        end

        private

        # :reek:FeatureEnvy
        def render version, response
          settings.firmware_root.join("#{version}.bin").delete
          response.with body: "", status: 200
        rescue Errno::ENOENT
          response.with body: "Unable to delete Version #{version}.", status: 404
        end
      end
    end
  end
end
