# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Sleeper, :db do
  subject(:sleeper) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device, model_id: model.id, friendly_id: "ABC123"] }
    let(:model) { Factory[:model] }

    it "answers existing screen when found" do
      screen = Factory[:screen, model_id: model.id, name: "terminus_sleep_abc123"]

      expect(sleeper.call(device).success).to have_attributes(
        id: screen.id,
        label: "Sleep ABC123",
        name: "terminus_sleep_abc123"
      )
    end

    it "answers new screen when not found" do
      expect(sleeper.call(device).success).to have_attributes(
        label: "Sleep ABC123",
        name: "terminus_sleep_abc123",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "terminus_sleep_abc123.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end
  end
end
