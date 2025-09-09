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
            in Success(*payload)
              delete payload.map(&:name)
              upsert payload
            else result
          end
        end

        private

        def delete remote_names
          locals = repository.where kind: "core"
          local_names = locals.map(&:name)

          repository.delete_all kind: "core", name: local_names - remote_names
        end

        def upsert payload
          payload.each do |item|
            attributes = item.to_h
            record = repository.find_by name: item.name

            if record
              repository.update(record.id, **attributes)
            else
              repository.create(**attributes)
            end
          end
        end
      end
    end
  end
end
