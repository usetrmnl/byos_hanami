# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Placeholder do
  subject(:placeholder) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(placeholder).to have_attributes(
        id: 0,
        label: "Placeholder",
        name: "placeholder",
        image_uri: Hanami.app[:assets]["setup.svg"].path,
        width: 800,
        height: 480
      )
    end

    it "answers custom attributes" do
      attributes = {id: 1, label: "Test", name: "test", uri: "blank.svg", width: 200, height: 100}

      expect(described_class[**attributes]).to have_attributes(
        id: 1,
        label: "Test",
        name: "test",
        image_uri: Hanami.app[:assets]["blank.svg"].path,
        width: 200,
        height: 100
      )
    end
  end

  describe "#image_uri" do
    it "answers asset path" do
      expect(placeholder.image_uri).to eq(Hanami.app[:assets]["setup.svg"].path)
    end
  end

  describe "#popover_attributes" do
    it "answers attributes" do
      expect(placeholder.popover_attributes).to eq(
        id: 0,
        label: "Placeholder",
        uri: Hanami.app[:assets]["setup.svg"].path,
        width: 800,
        height: 480
      )
    end
  end
end
