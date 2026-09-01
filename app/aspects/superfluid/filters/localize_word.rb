# frozen_string_literal: true

module Terminus
  module Aspects
    module Superfluid
      module Filters
        # Renders local word.
        class LocalizeWord
          include Deps[:i18n]

          def call(value, locale = "en") = i18n.translate value, locale:
        end
      end
    end
  end
end
