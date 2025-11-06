# frozen_string_literal: true

module Terminus
  module Relations
    # The extension and model join relation.
    class ExtensionModel < DB::Relation
      schema :extension_model, infer: true do
        associations do
          belongs_to :extension, relation: :extension
          belongs_to :model, relation: :model
        end
      end
    end
  end
end
