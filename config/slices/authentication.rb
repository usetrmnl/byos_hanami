# frozen_string_literal: true

module Authentication
  # The health slice configuration.
  class Slice < Hanami::Slice
    import keys: ["assets"], from: Hanami.app.container, as: :main
  end
end
