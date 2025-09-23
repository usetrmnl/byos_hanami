# auto_register: false
# frozen_string_literal: true

module Authentication
  # The slice view.
  class View < Terminus::View
    config.paths += ["app/templates"]
  end
end
