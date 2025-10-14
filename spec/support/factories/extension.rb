# frozen_string_literal: true

Factory.define :extension, relation: :extension do |factory|
  factory.sequence(:name) { "extension_#{it}" }
  factory.sequence(:label) { "Extension #{it}" }

  factory.trait :with_logo do |trait|
    trait.logo_data do
      {
        id: "logo.png",
        storage: "store",
        metadata: {
          bit_depth: 16,
          filename: "logo.png",
          height: 512,
          mime_type: "image/png",
          size: 50,
          width: 512
        }
      }
    end
  end
end
