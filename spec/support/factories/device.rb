# frozen_string_literal: true

Factory.define :device do |factory|
  factory.association :model

  factory.friendly_id "ABC123"
  factory.label "Test"
  factory.api_key "abc123"
  factory.mac_address "A1:B2:C3:D4:E5:F6"
  factory.battery 3.0
  factory.wifi(-44)
  factory.firmware_version "1.2.3"
  factory.proxy false
end
