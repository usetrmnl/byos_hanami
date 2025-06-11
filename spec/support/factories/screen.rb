# frozen_string_literal: true

Factory.define :screen do |factory|
  factory.label "Test"
  factory.name "test"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }
end
