# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Welcomer, :db do
  using Refinements::Pathname

  subject(:welcomer) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }

    it "creates welcome screen" do
      welcomer.call device
      expect(temp_dir.join(device.slug, "setup.png").exist?).to be(true)
    end

    it "answers output path" do
      expect(welcomer.call(device)).to be_success(temp_dir.join("A1B2C3D4E5F6/setup.png"))
    end

    context "when welcome screen exists" do
      subject(:welcomer) { described_class.new creator: }

      let(:creator) { instance_spy Terminus::Screens::HTMLSaver }

      before { temp_dir.join(device.slug, "setup.png").deep_touch }

      it "doesn't create screen" do
        welcomer.call device
        expect(creator).not_to have_received(:call)
      end

      it "answers output path" do
        expect(welcomer.call(device)).to be_success(temp_dir.join("A1B2C3D4E5F6/setup.png"))
      end
    end

    it "doesn't create screen when device creation is greater than or equal to maximum seconds" do
      welcomer.call device, now: Time.now + 30
      expect(temp_dir.join(device.slug, "setup.png").exist?).to be(false)
    end
  end
end
