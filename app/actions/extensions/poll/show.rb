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
          include Dry::Monads[:result]

          params { required(:id).filled :integer }

          # TODO: This is a duplicate of what is found in the Poll renderer.
          def self.reduce collection
            collection.each do |key, value|
              collection[key] = value.success? ? value.success : value.failure
            end
          end

          def handle request, response
            parameters = request.params

            halt :unprocessable_content unless parameters.valid?

            extension = repository.find parameters[:id]

            halt :not_found unless extension

            response.render view, body: body_for(extension), layout: false
          end

          private

          def body_for extension
            case fetch extension
              in Success(body) then body
              in Failure(message) then message
              else "Unable to render body for extension: #{extension.id}."
            end
          end

          def fetch extension
            fetcher.call(extension)
                   .fmap { |collection| self.class.reduce collection }
                   .fmap { |data| data.one? ? data["0"] : data }
                   .fmap do |data|
                     JSON data, indent: "  ", space: " ", object_nl: "\n", array_nl: "\n"
                   end
          end
        end
      end
    end
  end
end
