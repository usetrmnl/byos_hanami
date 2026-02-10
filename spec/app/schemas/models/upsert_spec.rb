# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Models::Upsert do
  subject(:contract) { described_class }

  describe "#call" do
    let :attributes do
      {
        name: "test",
        label: "Test",
        description: "A test.",
        mime_type: "image/png",
        colors: 16,
        bit_depth: 4,
        rotation: 0,
        offset_x: 0,
        offset_y: 0,
        scale_factor: 1.8,
        width: 1872,
        height: 1404,
        palette_ids: "bw gray-4 gray-16",
        css: {classes: {size: "screen--lg", device: "screen--v2"}}.to_json
      }
    end

    it "answers success when all attributes are valid" do
      expect(contract.call(attributes).to_monad).to be_success
    end

    it "answers palette IDs array" do
      expect(contract.call(attributes).to_h).to include(palette_ids: %w[bw gray-4 gray-16])
    end

    it "answers CSS hash" do
      expect(contract.call(attributes).to_h).to include(
        css: {
          "classes" => {
            "device" => "screen--v2",
            "size" => "screen--lg"
          }
        }
      )
    end
  end
end
