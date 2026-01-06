# frozen_string_literal: true

module Terminus
  module Views
    module Devices
      module Logs
        # The index view.
        class Index < View
          expose :device
          expose :logs
          expose :query
        end
      end
    end
  end
end
