# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Screens::Welcome::New do
  subject(:view) { described_class.new }

  let(:device) { Factory.structs[:device] }

  describe "#call" do
    it "includes greeting" do
      expect(view.call(device:).to_s).to include("Welcome to Terminus!")
    end

    it "includes friendly ID" do
      expect(view.call(device:).to_s).to include(%(<dd class="value">ABC123</dd>))
    end

    it "includes MAC Address" do
      expect(view.call(device:).to_s).to include(%(<dd class="value">A1:B2:C3:D4:E5:F6</dd>))
    end
  end
end
