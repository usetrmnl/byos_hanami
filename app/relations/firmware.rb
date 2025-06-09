# frozen_string_literal: true

module Terminus
  module Relations
    # The firmware relation.
    class Firmware < DB::Relation
      schema :firmwares, infer: true
    end
  end
end
