# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Contracts::API::Device do
  subject(:contract) { described_class }

  describe "#call" do
    let :attributes do
      {
        label: "Test",
        friendly_id: "ABC123",
        mac_address: "aa:bb:cc:11:22:33",
        api_key: "secret",
        refresh_rate: 100,
        image_timeout: 0,
        proxy: "on"
      }
    end

    it "answers success when all attributes are valid" do
      expect(described_class.call(attributes).to_monad).to be_success
    end

    it "answers true when proxy is truthy" do
      expect(described_class.call(attributes).to_h).to include(proxy: true)
    end

    it "answers false when proxy key is missing" do
      attributes.delete :proxy
      expect(described_class.call(attributes).to_h).to include(proxy: false)
    end
  end
end
