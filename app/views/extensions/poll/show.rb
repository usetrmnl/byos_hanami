# frozen_string_literal: true

require "dry/core"

module Terminus
  module Views
    module Extensions
      module Poll
        # The show view.
        class Show < View
          expose :content
          expose :errors, default: Dry::Core::EMPTY_HASH
        end
      end
    end
  end
end
