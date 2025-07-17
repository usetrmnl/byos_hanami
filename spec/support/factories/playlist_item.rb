# frozen_string_literal: true

Factory.define :playlist_item, relation: :playlist_item do |factory|
  factory.association :playlist
  factory.association :screen
  factory.sequence(:position) { it }
end
