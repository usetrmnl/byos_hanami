# frozen_string_literal: true

require "initable"

module Terminus
  module Actions
    module Extensions
      module Exchanges
        # The create action.
        class Create < Action
          include Deps[
            "aspects.errors.detailer",
            extension_repository: "repositories.extension",
            repository: "repositories.extension_exchange"
          ]
          include Initable[job: Jobs::Extensions::ExchangeRefresh]

          contract Contracts::Extensions::Exchanges::Create

          def handle request, response
            parameters = request.params

            if parameters.valid?
              save parameters, response
            else
              error parameters, response
            end
          end

          private

          def save parameters, response
            extension_id, exchange = parameters.to_h.values_at :extension_id, :exchange
            job.perform_async repository.create(extension_id:, **exchange).id

            response.redirect_to routes.path(
              :extension_exchanges,
              extension_id: parameters[:extension_id]
            )
          end

          def error parameters, response
            extension_id, fields = parameters.to_h.values_at :extension_id, :exchange
            errors = parameters.errors[:exchange]

            response.flash.now[:alert] = detailer.call errors, "Exchange "
            response.render view,
                            extension: extension_repository.find(extension_id),
                            fields:,
                            errors:
          end
        end
      end
    end
  end
end
