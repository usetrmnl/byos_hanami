# frozen_string_literal: true

module Terminus
  module Actions
    module Designer
      # The show action.
      class Show < Terminus::Action
        def handle _request, response
          response.render view, id: Time.new.utc.to_i
        end
      end
    end
  end
end
