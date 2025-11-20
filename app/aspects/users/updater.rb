# frozen_string_literal: true

require "refinements/string"

module Terminus
  module Aspects
    module Users
      # Validates and updates an existing user.
      class Updater
        include Deps[
          "aspects.password_encryptor",
          contract: "contracts.users.update",
          repository: "repositories.user",
          password_relation: "relations.user_password_hash"
        ]
        include Dry::Monads[:result]

        using Refinements::String

        def call(**attributes)
          result = contract.call(attributes).to_monad

          return result if result.failure?

          Success update(attributes[:id], attributes[:user])
        end

        private

        def update id, attributes
          password = attributes.delete :password
          user = repository.update(id, **attributes).then { repository.find id }

          update_password user, password
        end

        def update_password user, value
          return user if String(value).blank?

          id = user.id

          password_relation.by_pk(id).delete
          password_relation.upsert id: id, password_hash: password_encryptor.call(value)
          user
        end
      end
    end
  end
end
