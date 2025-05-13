# frozen_string_literal: true

module Terminus
  module Actions
    module Bulk
      module Firmware
        # The delete action.
        class Delete < Terminus::Action
          include Deps["aspects.firmware.fetcher"]

          using Refines::Actions::Response

          def handle _request, response
            fetcher.call.each do |record|
              Pathname(config.public_directory).join(record.path).delete
            end

            response.render view, layout: false
          rescue Errno::ENOENT
            response.with body: "Unable to delete firmware.", status: 500
          end
        end
      end
    end
  end
end
