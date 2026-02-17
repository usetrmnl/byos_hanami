# frozen_string_literal: true

Factory.define :device_sensor, relation: :device_sensor do |factory|
  factory.association :device
  factory.make "ACME"
  factory.model "Test"
  factory.kind "temperature"
  factory.value 20.10
  factory.unit "celcius"
  factory.source "device"
  factory.created_at Time.new(2025, 1, 1).utc
end
