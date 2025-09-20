# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Authentication
      # The main authentication view.
      class View < Terminus::View
        config.layout = "authentication"
      end
    end
  end
end
