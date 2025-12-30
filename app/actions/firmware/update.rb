# frozen_string_literal: true

module Terminus
  module Actions
    module Firmware
      # The update action.
      class Update < Terminus::Action
        include Deps[repository: "repositories.firmware", show_view: "views.firmware.show"]

        params do
          required(:id).filled :integer

          required(:firmware).filled(:hash) do
            required(:version).filled :string
            required(:kind).filled :string
          end
        end

        def handle request, response
          parameters = request.params
          firmware = repository.find parameters[:id]

          halt :unprocessable_content unless firmware

          if parameters.valid?
            save firmware, parameters, response
          else
            error firmware, parameters, response
          end
        end

        private

        def save firmware, parameters, response
          id = firmware.id
          repository.update id, **parameters[:firmware]

          response.render show_view, firmware: repository.find(id), layout: false
        end

        def error firmware, parameters, response
          response.render view,
                          firmware:,
                          fields: parameters[:firmware],
                          errors: parameters.errors[:firmware],
                          layout: false
        end
      end
    end
  end
end
