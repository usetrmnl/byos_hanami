# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The delete action.
      class Delete < Terminus::Action
        include Deps["aspects.jobs.schedule", repository: "repositories.extension"]

        def handle request, response
          extension = repository.find request.params[:id]

          halt :unprocessable_content unless extension

          repository.delete extension.id
          schedule.delete extension.screen_name
          response.body = ""
        end
      end
    end
  end
end
