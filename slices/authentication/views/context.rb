# auto_register: false
# frozen_string_literal: true

module Authentication
  module Views
    # The slice view context.
    class Context < Hanami::View::Context
      include Deps[main_assets: "main.assets"]
    end
  end
end
