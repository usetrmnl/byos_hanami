# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Sleeper, :db do
  subject(:welcomer) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device, friendly_id: "ABC123"] }

    it "creates sleep screen" do
      expect(welcomer.call(device).success).to have_attributes(
        label: "Sleep ABC123",
        name: "sleep_abc123",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "sleep_abc123.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end
  end
end
