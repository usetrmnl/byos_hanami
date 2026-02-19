# frozen_string_literal: true

Factory.define :extension_device, relation: :extension_device do |factory|
  factory.association :extension
  factory.association :device
end
