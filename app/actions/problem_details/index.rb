# frozen_string_literal: true

module Terminus
  module Actions
    module ProblemDetails
      # The index action.
      class Index < Terminus::Action
        def handle(_request, response) = response.render view
      end
    end
  end
end
