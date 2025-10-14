# frozen_string_literal: true

module Terminus
  module Relations
    # The extension relation.
    class Extension < DB::Relation
      schema :extension, infer: true
    end
  end
end
