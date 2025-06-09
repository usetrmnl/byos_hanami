# frozen_string_literal: true

Factory.define :firmware do |factory|
  factory.version "0.0.0"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }

  factory.trait :with_attachment do |trait|
    trait.attachment_data do
      {
        id: "abc123.bin",
        storage: "store",
        metadata: {
          size: 4,
          width: nil,
          height: nil,
          filename: "test.bin",
          mime_type: "application/octet-stream"
        }
      }
    end
  end
end
