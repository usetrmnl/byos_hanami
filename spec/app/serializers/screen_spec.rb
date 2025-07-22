# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Serializers::Screen, :db do
  subject(:serializer) { described_class.new screen }

  let(:screen) { Factory[:screen, :with_image, **attributes] }
  let(:model) { Factory[:model] }

  let :attributes do
    {
      id: 1,
      model_id: model.id,
      label: "Test",
      name: "test",
      created_at: "2025-01-01T00:00:00+0000",
      updated_at: "2025-02-02T00:00:00+0000"
    }
  end

  describe "#to_h" do
    it "answers hash with image attributes" do
      expect(serializer.to_h).to eq(
        model_id: model.id,
        uri: "memory://abc123.png",
        filename: "test.png",
        mime_type: "image/png",
        width: 1,
        height: 1,
        size: 1,
        **attributes
      )
    end

    it "answers hash without image attributes" do
      serializer = described_class.new Factory[:screen, **attributes]
      expect(serializer.to_h).to eq(model_id: model.id, **attributes)
    end
  end
end
