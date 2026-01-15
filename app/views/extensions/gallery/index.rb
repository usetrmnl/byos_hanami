# frozen_string_literal: true

module Terminus
  module Views
    module Extensions
      module Gallery
        # The index view.
        class Index < Hanami::View
          expose :payload
          expose :query, decorate: false
          expose(:next_page, decorate: false) { |payload:| payload.current_page + 1 }
        end
      end
    end
  end
end
