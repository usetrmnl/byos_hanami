# frozen_string_literal: true

require "dry/monads"
require "initable"

module Terminus
  module Actions
    module Extensions
      module Poll
        # The show action.
        class Show < Terminus::Action
          include Deps[
            repository: "repositories.extension",
            fetcher: "aspects.extensions.multi_fetcher"
          ]
          include Initable[json_formatter: Aspects::JSONFormatter]
          include Dry::Monads[:result]

          # TODO: This is a duplicate of what is found in the Poll renderer.
          def self.reduce collection
            collection.each do |key, value|
              collection[key] = value.success? ? value.success : value.failure
            end
          end

          def handle request, response
            extension = repository.find request.params[:id]

            halt :not_found unless extension

            response.render view, body: body_for(extension), layout: false
          end

          private

          def body_for extension
            case fetch extension
              in Success(body) then body
              in Failure(message) then message
              # :nocov:
              # :nocov:
            end
          end

          def fetch extension
            fetcher.call(extension)
                   .fmap { |collection| self.class.reduce collection }
                   .fmap { |data| data.one? ? data["source_1"] : data }
                   .fmap { |data| data.is_a?(Hash) ? json_formatter.call(data) : data }
          end
        end
      end
    end
  end
end
