# frozen_string_literal: true

Factory.define :extension_model, relation: :extension_model do |factory|
  factory.association :extension
  factory.association :model
end
