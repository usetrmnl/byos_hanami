# frozen_string_literal: true

Factory.define :user, relation: :user do |factory|
  factory.sequence(:email) { "user_#{it}@test.io" }
  factory.sequence(:name) { "User #{it}" }

  factory.trait(:verified) { |trait| trait.status_id 2 }
end
