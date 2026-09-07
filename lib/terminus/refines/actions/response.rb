# frozen_string_literal: true

module Terminus
  module Refines
    module Actions
      # Modifies and enhances default Hanami action response behavior.
      module Response
        refine Hanami::Action::Response do
          def with_details problem
            with body: problem.to_json, format: :problem_details, status: problem.status
          end

          def with body:, format: nil, status: 200
            @body = [body]
            @status = status

            self.format = format if format
            self
          end
        end
      end
    end
  end
end
