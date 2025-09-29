# frozen_string_literal: true

module Terminus
  module Views
    module Users
      # The show view.
      class Show < Terminus::View
        expose :user
      end
    end
  end
end
