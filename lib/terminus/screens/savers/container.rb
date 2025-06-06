# frozen_string_literal: true

require "containable"

module Terminus
  module Screens
    module Savers
      # Registers all savers.
      module Container
        extend Containable

        register(:encoded) { Encoded.new }
        register(:html) { HTML.new }
        register(:preprocessed_uri) { PreprocessedURI.new }
        register(:unprocessed_uri) { UnprocessedURI.new }
      end
    end
  end
end
