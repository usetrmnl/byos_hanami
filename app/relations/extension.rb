# frozen_string_literal: true

module Terminus
  module Relations
    # The extension relation.
    class Extension < DB::Relation
      schema :extension, infer: true do
        associations do
          has_many :extension_models, relation: :extension_model
          has_many :models, through: :extension_model, relation: :model, as: :models
        end
      end
    end
  end
end
