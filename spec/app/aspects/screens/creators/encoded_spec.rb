# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::Encoded, :db do
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with temporary directory"
  include_context "with screen mold"

  describe "#call" do
    let(:model) { Factory[:model] }

    before do
      mold.with! model_id: model.id,
                 content: Base64.strict_encode64(SPEC_ROOT.join("support/fixtures/test.png").read)
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
