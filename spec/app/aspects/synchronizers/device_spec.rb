# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Synchronizers::Device, :db do
  subject(:updater) { described_class.new }

  include_context "with firmware headers"

  describe "#call" do
    let(:device) { Factory[:device] }

    it "updates device upon success" do
      device

      expect(updater.call(firmware_headers)).to match(
        Success(
          have_attributes(
            battery: 4.74,
            firmware_version: "1.2.3",
            wifi: -54,
            width: 800,
            height: 480
          )
        )
      )
    end

    it "fails to update device upon failure" do
      expect(updater.call(firmware_headers)).to be_failure("Unable to find device by API key.")
    end
  end
end
