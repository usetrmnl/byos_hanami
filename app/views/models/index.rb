# frozen_string_literal: true

module Terminus
  module Views
    module Models
      # The index view.
      class Index < Hanami::View
        expose :models
        expose :query
      end
    end
  end
end
