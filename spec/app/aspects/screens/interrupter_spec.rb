# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Interrupter do
  subject(:interrupter) { described_class.new positioner: }

  let(:positioner) { instance_spy Terminus::Aspects::Screens::Positioner }

  describe "#call" do
    let(:device) { Factory.structs[:device] }

    it "processes device identify command" do
      device = Factory.structs[:device, command: "identify"]
      identify = instance_spy Terminus::Aspects::Screens::Interrupts::Identify
      interrupter = described_class.new(identify:)

      interrupter.call device, trigger: "button"

      expect(identify).to have_received(:call).with(device)
    end

    it "processes device screen first command" do
      device = Factory.structs[:device, command: "screen_first"]
      interrupter.call device, trigger: "button"

      expect(positioner).to have_received(:call).with(device, direction: :first)
    end

    it "processes device screen backward command" do
      device = Factory.structs[:device, command: "screen_backward"]
      interrupter.call device, trigger: "button"

      expect(positioner).to have_received(:call).with(device, direction: :backward)
    end

    it "processes device screen forward command" do
      device = Factory.structs[:device, command: "screen_forward"]
      interrupter.call device, trigger: "button"

      expect(positioner).to have_received(:call).with(device, direction: :forward)
    end

    it "processes device screen last command" do
      device = Factory.structs[:device, command: "screen_last"]
      interrupter.call device, trigger: "button"

      expect(positioner).to have_received(:call).with(device, direction: :last)
    end

    it "sleeps when device is asleep" do
      device = Factory.structs[:device]
      sleep = instance_spy Terminus::Aspects::Screens::Interrupts::Sleep
      interrupter = described_class.new(sleep:)

      allow(device).to receive(:asleep?).and_return(true)
      interrupter.call device, trigger: "button"

      expect(sleep).to have_received(:call).with(device)
    end

    it "forwards to next screen when trigger is unknown" do
      device = Factory.structs[:device]
      interrupter.call device

      expect(positioner).to have_received(:call).with(device, direction: :forward)
    end

    it "forwards to next screen when device command is unknown" do
      device = Factory.structs[:device, command: "anything"]
      interrupter.call device, trigger: "button"

      expect(positioner).to have_received(:call).with(device, direction: :forward)
    end
  end
end
