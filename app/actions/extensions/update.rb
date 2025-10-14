# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Extensions
      # The update action.
      class Update < Terminus::Action
        include Deps[repository: "repositories.extension"]
        include Initable[job: Terminus::Jobs::ExtensionScreenUpserter]

        contract Contracts::Extensions::Update

        def handle request, response
          parameters = request.params
          extension = repository.find parameters[:id]

          halt :unprocessable_content unless extension

          if parameters.valid?
            save extension, parameters, response
          else
            error extension, parameters, response
          end
        end

        private

        # :reek:TooManyStatements
        def save extension, parameters, response
          id = extension.id
          attributes, model_ids = parameters.to_h.values_at :extension, :model_ids
          repository.update_with_models id, attributes, Array(model_ids)
          enqueue id, model_ids

          response.flash.now[:notice] = "Changes saved."
          response.render view, extension: repository.find(id)
        end

        # :reek:FeatureEnvy
        def error extension, parameters, response
          response.render view,
                          extension:,
                          fields: parameters[:extension],
                          errors: parameters.errors[:extension],
                          layout: false
        end

        def enqueue extension_id, model_ids
          model_ids.each { |model_id| job.perform_async extension_id, model_id }
        end
      end
    end
  end
end
