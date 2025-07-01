# frozen_string_literal: true

Factory.define :screen, relation: :screen do |factory|
  factory.association :model
  factory.sequence(:label) { "Screen #{it}" }
  factory.sequence(:name) { "screen_#{it}" }

  factory.trait :with_image do |trait|
    trait.image_data do
      {
        id: "abc123.png",
        storage: "store",
        metadata: {
          size: 1,
          width: 1,
          height: 1,
          filename: "test.png",
          mime_type: "image/png"
        }
      }
    end
  end
end
