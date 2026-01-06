# frozen_string_literal: true

module Terminus
  module Views
    module Devices
      module Logs
        # The show view.
        class Show < View
          expose :device
          expose :log
        end
      end
    end
  end
end
