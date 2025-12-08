# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      module Build
        # The create action.
        class Create < Terminus::Action
          include Deps[:htmx, repository: "repositories.extension"]
          include Initable[job: Terminus::Jobs::Batches::Extension]

          params { required(:id).filled :integer }

          def handle request, response
            extension = repository.find request.params[:id]
            enqueue extension, response
          end

          private

          def enqueue extension, response
            job.perform_async extension.id

            response.status = 202
            response.render view, extension:, layout: false
          end
        end
      end
    end
  end
end
