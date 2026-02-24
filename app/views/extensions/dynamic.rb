# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      # The dynamic view.
      class Dynamic < View
        config.layout = "extension"

        expose :content
      end
    end
  end
end
