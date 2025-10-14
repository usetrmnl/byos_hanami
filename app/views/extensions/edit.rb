# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      # The edit view.
      class Edit < Terminus::View
        include Deps[model_repository: "repositories.model"]

        expose(:models) { model_repository.all.map { [it.label, it.id] } }
        expose :extension
        expose :fields, default: Dry::Core::EMPTY_HASH
        expose :errors, default: Dry::Core::EMPTY_HASH
      end
    end
  end
end
