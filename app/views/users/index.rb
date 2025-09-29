# frozen_string_literal: true

module Terminus
  module Views
    module Users
      # The index view.
      class Index < Hanami::View
        expose :users
        expose :query
      end
    end
  end
end
