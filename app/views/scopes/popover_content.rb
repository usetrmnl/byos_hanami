# frozen_string_literal: true

module Terminus
  module Views
    module Scopes
      # Provides customized popover content.
      class PopoverContent < Hanami::View::Scope
        def id = "popover-#{name}"

        def render(path = "shared/popovers/content") = super
      end
    end
  end
end
