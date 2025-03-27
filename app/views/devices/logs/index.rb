# frozen_string_literal: true

module Terminus
  module Views
    module Devices
      module Logs
        # The index view.
        class Index < Terminus::View
          expose :device
          expose :logs
        end
      end
    end
  end
end
