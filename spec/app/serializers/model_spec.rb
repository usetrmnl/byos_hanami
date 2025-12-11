# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Serializers::Model do
  subject(:serializer) { described_class.new model }

  let(:model) { Factory.structs[:model, **attributes] }

  let :attributes do
    {
      name: "t1",
      label: "T1",
      description: nil,
      kind: "core",
      mime_type: "image/bmp",
      colors: 4,
      bit_depth: 2,
      rotation: 90,
      offset_x: 10,
      offset_y: 15,
      width: 800,
      height: 480,
      created_at: "2025-01-01T10:10:10+0000",
      updated_at: "2025-01-01T10:10:10+0000"
    }
  end

  describe "#to_h" do
    it "answers explicit hash" do
      expect(serializer.to_h).to eq(id: model.id, **attributes)
    end
  end
end
