# frozen_string_literal: true

Factory.define :model, relation: :model do |factory|
  factory.sequence(:label) { "T#{it}" }
  factory.sequence(:name) { "t#{it}" }
  factory.kind { "terminus" }
  factory.mime_type "image/png"
  factory.rotation 0
  factory.offset_x 0
  factory.offset_y 0
  factory.width 800
  factory.height 480
  factory.scale_factor 1
  factory.published_at { Time.now }
end
