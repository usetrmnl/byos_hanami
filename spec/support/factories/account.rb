# frozen_string_literal: true

Factory.define :account, relation: :account do |factory|
  factory.sequence(:name) { "test_#{it}" }
  factory.sequence(:label) { "Test #{it}" }
end
