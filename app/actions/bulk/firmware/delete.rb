# frozen_string_literal: true

module Terminus
  module Actions
    module Bulk
      module Firmware
        # The delete action.
        class Delete < Terminus::Action
          include Deps[repository: "repositories.firmware"]

          using Refines::Actions::Response

          def handle _request, response
            repository.delete_all
            response.render view, layout: false
          end
        end
      end
    end
  end
end
