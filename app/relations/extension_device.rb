# frozen_string_literal: true

module Terminus
  module Relations
    # The extension and device join relation.
    class ExtensionDevice < DB::Relation
      schema :extension_device, infer: true do
        associations do
          belongs_to :extension, relation: :extension
          belongs_to :device, relation: :device
        end
      end
    end
  end
end
