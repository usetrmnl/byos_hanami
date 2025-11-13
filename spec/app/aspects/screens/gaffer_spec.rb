# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Gaffer, :db do
  subject(:gaffer) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device, friendly_id: "ABC123"] }
    let(:message) { "Danger!" }

    it "creates screen" do
      expect(gaffer.call(device, message).success).to have_attributes(
        label: "Error ABC123",
        name: "terminus_error_abc123",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "terminus_error_abc123.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end

    it "updates screen" do
      Factory[
        :screen,
        model_id: device.model_id,
        label: "Error ABC123",
        name: "terminus_error_abc123"
      ]

      expect(gaffer.call(device, message).success).to have_attributes(
        label: "Error ABC123",
        name: "terminus_error_abc123",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "terminus_error_abc123.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end
  end
end
