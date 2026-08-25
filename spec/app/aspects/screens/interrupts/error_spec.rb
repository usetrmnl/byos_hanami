# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Interrupts::Error, :db do
  subject(:gaffer) { described_class.new }

  describe "#call" do
    let(:device) { Factory[:device, model_id: model.id] }
    let(:model) { Factory[:model] }
    let(:message) { "Danger!" }

    it "answers new screen when not found" do
      expect(gaffer.call(device, message).success).to have_attributes(
        label: "Error #{device.id}",
        name: "error_#{device.id}",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "error_#{device.id}.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end

    it "answers updates existing screen when found" do
      Factory[
        :screen,
        model_id: device.model_id,
        label: "Error #{device.id}",
        name: "error_#{device.id}"
      ]

      expect(gaffer.call(device, message).success).to have_attributes(
        label: "Error #{device.id}",
        name: "error_#{device.id}",
        image_attributes: hash_including(
          metadata: hash_including(
            filename: "error_#{device.id}.png",
            mime_type: "image/png",
            width: 800,
            height: 480
          )
        )
      )
    end
  end
end
