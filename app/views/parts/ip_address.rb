# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The dashboard presenter.
      class IPAddress < Hanami::View::Part
        def address = addr.ip_address

        def address_with_kind = "#{address} (#{kind})"

        def kind = name == "en0" ? :wireless : :wired
      end
    end
  end
end
