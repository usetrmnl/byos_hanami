# frozen_string_literal: true

module Terminus
  module Views
    module Users
      # The new view.
      class New < Terminus::View
        expose :user
        expose :statuses
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
