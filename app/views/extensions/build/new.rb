# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      module Build
        # The new view.
        class New < Terminus::View
          expose :extension
        end
      end
    end
  end
end
