# frozen_string_literal: true

Factory.define :device do |factory|
  factory.friendly_id "ABC123"
  factory.label "Test"
  factory.api_key "abc123"
  factory.mac_address "A1:B2:C3:D4:E5:F6"
  factory.proxy false
  factory.created_at { Time.now }
  factory.updated_at { Time.now }
end
