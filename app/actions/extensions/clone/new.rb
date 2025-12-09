# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      module Clone
        # The new action.
        class New < Hanami::Action
          include Deps[repository: "repositories.extension"]

          params { required(:extension_id).filled :integer }

          def handle request, response
            extension = repository.find request.params[:extension_id]
            fields = {label: "#{extension.label} Clone", name: "#{extension.name}_clone"}

            response.render view, extension:, fields:
          end
        end
      end
    end
  end
end
