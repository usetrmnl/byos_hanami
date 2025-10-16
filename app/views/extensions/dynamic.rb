# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      # The dynamic view.
      class Dynamic < Terminus::View
        config.layout = "extension"

        expose :body
      end
    end
  end
end
