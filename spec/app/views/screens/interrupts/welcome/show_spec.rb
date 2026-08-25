# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Screens::Interrupts::Welcome::Show do
  subject(:view) { described_class.new }

  let(:device) { Factory.structs[:device, id: 1] }

  describe "#call" do
    it "includes greeting" do
      expect(view.call(device:).to_s).to include("Welcome to Terminus!")
    end

    it "includes ID" do
      expect(view.call(device:).to_s).to include(%(<dd class="value">1</dd>))
    end
  end
end
