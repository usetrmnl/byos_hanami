# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    module Parts
      # The user presenter.
      class User < Hanami::View::Part
        attr_accessor :password

        def pill
          case status_id
            when 1 then "caution"
            when 2 then "active"
            when 3 then "inactive"
            else "unknown"
          end
        end
      end
    end
  end
end
