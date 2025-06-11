# frozen_string_literal: true

Factory.define :screen do |factory|
  factory.label "Test"
  factory.name "test"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }

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
