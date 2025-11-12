# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::ScreenUpserter, :db do
  using Refinements::Struct

  subject(:upserter) { described_class.new }

  describe "#call" do
    let(:extension) { Factory.structs[:extension, label: "Test", name: "test"] }
    let(:model) { Factory[:model] }

    it "creates screen" do
      result = upserter.call extension, model.id

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "extension-test",
        label: "Extension Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "extension-test.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "updates screen" do
      Factory[:screen, model_id: model.id, label: "Extension Test", name: "extension-test"]
      result = upserter.call extension, model.id

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "extension-test",
        label: "Extension Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "extension-test.png",
            mime_type: "image/png"
          )
        )
      )
    end
  end
end
