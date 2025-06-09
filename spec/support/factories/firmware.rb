# frozen_string_literal: true

Factory.define :firmware do |factory|
  factory.version "0.0.0"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }
end
