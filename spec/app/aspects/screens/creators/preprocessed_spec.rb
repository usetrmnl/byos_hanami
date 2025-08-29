# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::Preprocessed, :db do
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with screen mold"

  describe "#call" do
    let(:model) { Factory[:model] }

    before { mold.merge! model_id: model.id, content: SPEC_ROOT.join("support/fixtures/test.png") }

    it "answers screen" do
      result = creator.call mold

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "test",
        label: "Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 1,
            height: 1,
            filename: "test.png",
            mime_type: "image/png"
          )
        )
      )
    end
  end
end
