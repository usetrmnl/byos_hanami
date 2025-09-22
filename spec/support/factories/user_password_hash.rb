# frozen_string_literal: true

Factory.define :user_password_hash, relation: :user_password_hash do |factory|
  factory.password_hash { BCrypt::Password.create "password", cost: BCrypt::Engine::MIN_COST }
end
