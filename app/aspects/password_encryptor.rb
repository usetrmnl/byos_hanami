# frozen_string_literal: true

require "bcrypt"
require "initable"

module Terminus
  module Aspects
    # Creates passwords with computation cost respective of environment.
    class PasswordEncryptor
      include Initable[
        password: BCrypt::Password,
        minimum: BCrypt::Engine::MIN_COST,
        maximum: BCrypt::Engine::DEFAULT_COST
      ]

      def call text, environment: Hanami.env
        cost = environment == :test ? minimum : maximum
        password.create text, cost:
      end
    end
  end
end
