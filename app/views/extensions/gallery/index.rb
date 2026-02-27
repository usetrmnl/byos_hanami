# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      module Gallery
        # The index view.
        class Index < Hanami::View
          expose :recipe
          expose :query, decorate: false
          expose :page, decorate: false
        end
      end
    end
  end
end
