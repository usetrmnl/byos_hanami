# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::Encoded do
  subject(:creator) { described_class.new }

  include_context "with temporary directory"

  describe "#call" do
    let :mold do
      Terminus::Aspects::Screens::Mold[
        content: "<p>Test</p>",
        mime_type: "image/png",
        bit_depth: 1,
        colors: 2,
        rotation: 0,
        offset_x: 0,
        offset_y: 0,
        width: 800,
        height: 480,
        input_path: SPEC_ROOT.join("support/fixtures/test.png"),
        output_path: temp_dir.join("test.png")
      ]
    end

    it "answers screen" do
      result = creator.call mold

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "test",
        label: "Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "test.png",
            mime_type: "image/png"
          )
        )
      )
    end
  end
end
