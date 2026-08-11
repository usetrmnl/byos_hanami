# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Device, :db do
  subject :device do
    Factory.structs[:device, image_timeout: 10, mac_address: "AA:BB:CC:11:22:33", refresh_rate: 20]
  end

  describe "#asleep?" do
    subject :device do
      Factory[
        :device,
        sleep_start_at: Time.utc(2025, 1, 1, 1, 1, 0),
        sleep_stop_at: Time.utc(2025, 1, 1, 1, 10, 0)
      ]
    end

    it "answers true when current time is within same day" do
      expect(device.asleep?(Time.utc(2025, 1, 1, 1, 5, 0))).to be(true)
    end

    it "answers false when current time is outside same day" do
      expect(device.asleep?(Time.utc(2025, 1, 1, 1, 20, 0))).to be(false)
    end

    context "when crossing midnight" do
      subject :device do
        Factory[
          :device,
          sleep_start_at: Time.utc(2025, 1, 1, 22, 0, 0),
          sleep_stop_at: Time.utc(2025, 1, 1, 5, 0, 0)
        ]
      end

      it "answers true when current time is within range" do
        expect(device.asleep?(Time.utc(2025, 1, 1, 1, 0, 0))).to be(true)
      end

      it "answers false when current time is outside range" do
        expect(device.asleep?(Time.utc(2025, 1, 1, 6, 0, 0))).to be(false)
      end
    end

    it "answers false when start and end are nil" do
      expect(Factory.structs[:device].asleep?).to be(false)
    end
  end

  describe "#battery_percentage" do
    it "answers percentage when charge is positive" do
      device = Factory.structs[:device, battery_charge: 85]
      expect(device.battery_percentage).to eq(85)
    end

    it "answers zero when charge and voltage are zero" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0]
      expect(device.battery_percentage).to eq(0)
    end

    it "answers ten percent when voltage is extremely low" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0.1]
      expect(device.battery_percentage).to eq(10)
    end

    it "answers ten percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0.25]
      expect(device.battery_percentage).to eq(10)
    end

    it "answers twenty percent when voltage is just above the ten percent band" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0.455]
      expect(device.battery_percentage).to eq(20)
    end

    it "answers twenty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0.75]
      expect(device.battery_percentage).to eq(20)
    end

    it "answers thirty percent when voltage is just above the twenty percent band" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 0.95]
      expect(device.battery_percentage).to eq(30)
    end

    it "answers thirty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 1.15]
      expect(device.battery_percentage).to eq(30)
    end

    it "answers fourty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 1.5]
      expect(device.battery_percentage).to eq(40)
    end

    it "answers fifty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 2.0]
      expect(device.battery_percentage).to eq(50)
    end

    it "answers sixty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 2.5]
      expect(device.battery_percentage).to eq(60)
    end

    it "answers seventy percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 3.0]
      expect(device.battery_percentage).to eq(70)
    end

    it "answers eighty percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 3.3]
      expect(device.battery_percentage).to eq(80)
    end

    it "answers ninety percent when voltage is just above the eighty percent band" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 3.605]
      expect(device.battery_percentage).to eq(90)
    end

    it "answers ninety percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 3.9]
      expect(device.battery_percentage).to eq(90)
    end

    it "answers one hundred percent when voltage is in range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 4.5]
      expect(device.battery_percentage).to eq(100)
    end

    it "answers one hundred percent when voltage is beyond range" do
      device = Factory.structs[:device, battery_charge: 0, battery_voltage: 4.8]
      expect(device.battery_percentage).to eq(100)
    end
  end

  describe "#display_attributes" do
    it "answers display specific attributes" do
      expect(device.display_attributes).to eq(
        image_url_timeout: 10,
        maximum_compatibility: false,
        refresh_rate: 20,
        temperature_profile: "default",
        touchbar_mode: "tap",
        update_firmware: true
      )
    end
  end

  describe "#slug" do
    it "answers string with no colons" do
      expect(device.slug).to eq("AABBCC112233")
    end

    it "answers empty string when slug is nil" do
      device = Factory.structs[:device, mac_address: nil]
      expect(device.slug).to eq("")
    end
  end

  describe "#screen_label" do
    it "answers label with prefix" do
      expect(device.screen_label("Welcome")).to eq("Welcome #{device.id}")
    end
  end

  describe "#screen_name" do
    it "answers name with kind" do
      expect(device.screen_name("welcome")).to eq("welcome_#{device.id}")
    end
  end

  describe "#screen_attributes" do
    it "answers attributes" do
      expect(device.screen_attributes("welcome")).to eq(
        device_id: device.id,
        model_id: device.model_id,
        label: "Welcome #{device.id}",
        name: "welcome_#{device.id}",
        kind: "welcome"
      )
    end
  end

  describe "#wifi_percentage" do
    it "answers zero when zero" do
      device = Factory.structs[:device, wifi_signal: 0]
      expect(device.wifi_percentage).to eq(0)
    end

    it "answers ten percent when extremely low" do
      device = Factory.structs[:device, wifi_signal: -100]
      expect(device.wifi_percentage).to eq(10)
    end

    it "answers ten percent when in range" do
      device = Factory.structs[:device, wifi_signal: -95]
      expect(device.wifi_percentage).to eq(10)
    end

    it "answers twenty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -85]
      expect(device.wifi_percentage).to eq(20)
    end

    it "answers thirty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -75]
      expect(device.wifi_percentage).to eq(30)
    end

    it "answers fourty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -69]
      expect(device.wifi_percentage).to eq(40)
    end

    it "answers fifty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -65]
      expect(device.wifi_percentage).to eq(50)
    end

    it "answers sixty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -59]
      expect(device.wifi_percentage).to eq(60)
    end

    it "answers seventy percent when in range" do
      device = Factory.structs[:device, wifi_signal: -54]
      expect(device.wifi_percentage).to eq(70)
    end

    it "answers eighty percent when in range" do
      device = Factory.structs[:device, wifi_signal: -49]
      expect(device.wifi_percentage).to eq(80)
    end

    it "answers ninety percent when in range" do
      device = Factory.structs[:device, wifi_signal: -45]
      expect(device.wifi_percentage).to eq(90)
    end

    it "answers one hundred percent when in range" do
      device = Factory.structs[:device, wifi_signal: -25]
      expect(device.wifi_percentage).to eq(100)
    end
  end
end
