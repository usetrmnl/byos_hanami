# frozen_string_literal: true

Factory.define :membership, relation: :membership do |factory|
  factory.association :account
  factory.association :user
end
