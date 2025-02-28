# frozen_string_literal: true

module Terminus
  module Refines
    module Actions
      # Modifies and enhances default Hanami action response behavior.
      module Response
        refine Hanami::Action::Response do
          def with body:, status:
            @body = [body]
            @status = status
            self
          end
        end
      end
    end
  end
end
