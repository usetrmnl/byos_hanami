# frozen_string_literal: true

Factory.define :device do |factory|
  factory.friendly_id "ABC123"
  factory.label "Test"
  factory.api_key "abc123"
  factory.mac_address "aa:bb:cc:00:11:22"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }
end
