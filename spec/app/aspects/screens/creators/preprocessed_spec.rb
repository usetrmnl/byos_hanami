# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::Preprocessed, :db do
  subject(:creator) { described_class.new }

  describe "#call" do
    let :payload do
      Terminus::Aspects::Screens::Creators::Payload[
        model:,
        name: "test",
        label: "Test",
        content: SPEC_ROOT.join("support/fixtures/test.png")
      ]
    end

    let(:model) { Factory[:model] }

    it "answers screen" do
      result = creator.call payload

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

    it "answers failure with database error" do
      result = creator.call payload.with(name: nil)
      expect(result.failure).to match(/null value/)
    end
  end
end
