# frozen_string_literal: true

module Terminus
  module Actions
    module Editor
      # The show action.
      class Show < Terminus::Action
        def handle _request, response
          response.render view, id: Time.new.to_i
        end
      end
    end
  end
end
