# frozen_string_literal: true

module Terminus
  module Actions
    module Extensions
      # The update action.
      class Update < Terminus::Action
        include Deps[repository: "repositories.extension", show_view: "views.extensions.show"]

        contract Contracts::Extensions::Update

        def handle request, response
          parameters = request.params
          extension = repository.find parameters[:id]

          halt :unprocessable_entity unless extension

          if parameters.valid?
            save extension, parameters, response
          else
            error extension, parameters, response
          end
        end

        private

        def save extension, parameters, response
          id = extension.id
          repository.update id, **parameters[:extension]

          response.render show_view, extension: repository.find(id), layout: false
        end

        # :reek:FeatureEnvy
        def error extension, parameters, response
          response.render view,
                          extension:,
                          fields: parameters[:extension],
                          errors: parameters.errors[:extension],
                          layout: false
        end
      end
    end
  end
end
