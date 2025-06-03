# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Device do
  subject(:contract) { described_class }

  describe "#call" do
    let :attributes do
      {
        label: "Test",
        friendly_id: "ABC123",
        mac_address: "AA:BB:CC:11:22:33",
        api_key: "secret",
        refresh_rate: 100,
        image_timeout: 0,
        proxy: "on",
        firmware_update: "on"
      }
    end

    it "answers success when all attributes are valid" do
      expect(contract.call(attributes).to_monad).to be_success
    end

    it "answers failure when refresh rate is less than zero" do
      attributes[:refresh_rate] = -1

      expect(contract.call(attributes).errors.to_h).to include(
        refresh_rate: ["must be greater than or equal to 10"]
      )
    end

    it "answers failure when image timeout is less than zero" do
      attributes[:image_timeout] = -1

      expect(contract.call(attributes).errors.to_h).to include(
        image_timeout: ["must be greater than or equal to 0"]
      )
    end

    it "answers true when proxy is truthy" do
      expect(contract.call(attributes).to_h).to include(proxy: true)
    end

    it "answers false when proxy key is missing" do
      attributes.delete :proxy
      expect(contract.call(attributes).to_h).to include(proxy: false)
    end

    it "answers true when firmware update is truthy" do
      expect(contract.call(attributes).to_h).to include(firmware_update: true)
    end

    it "answers false when firmware update key is missing" do
      attributes.delete :firmware_update
      expect(contract.call(attributes).to_h).to include(firmware_update: false)
    end
  end
end
