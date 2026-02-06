# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Placeholder do
  subject(:placeholder) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(placeholder).to have_attributes(
        label: "Placeholder",
        name: "placeholder",
        image_uri: "/assets/setup.svg",
        width: 800,
        height: 480
      )
    end

    it "answers custom attributes" do
      attributes = {
        id: 1,
        label: "Test",
        name: "test",
        image_uri: "/test.svg",
        width: 200,
        height: 100
      }

      expect(described_class[**attributes]).to have_attributes(attributes)
    end
  end

  describe "#popover_attributes" do
    it "answers attributes" do
      expect(placeholder.popover_attributes).to eq(
        id: nil,
        label: "Placeholder",
        uri: "/assets/setup.svg",
        width: 800,
        height: 480
      )
    end
  end
end
