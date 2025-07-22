# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module API
      module Screens
        # The index action.
        class Index < Base
          include Deps[repository: "repositories.screen"]
          include Initable[serializer: Serializers::Screen]

          def handle(*, response) = response.body = {data:}.to_json

          private

          def data = repository.all.map { serializer.new(it).to_h }
        end
      end
    end
  end
end
