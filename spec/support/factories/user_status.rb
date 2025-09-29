# frozen_string_literal: true

Factory.define :user_status, relation: :user_status do |factory|
  factory.name { "Unverified" }

  factory.trait(:verified) { it.name "Verified" }

  factory.trait(:closed) { it.name "Closed" }
end
