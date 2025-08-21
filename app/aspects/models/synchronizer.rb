# frozen_string_literal: true

module Terminus
  module Aspects
    module Models
      # A models synchronizer with Core server.
      class Synchronizer
        include Deps[:trmnl_api, repository: "repositories.model"]
        include Dry::Monads[:result]

        def call
          result = trmnl_api.models

          case result
            in Success(*payload) then upsert payload
            else result
          end
        end

        private

        def upsert payload
          payload.each do |item|
            attributes = item.to_h
            record = repository.find_by name: item.name

            if record
              repository.update record.id, kind: "core", **attributes
            else
              repository.create kind: "core", **attributes
            end
          end
        end
      end
    end
  end
end
