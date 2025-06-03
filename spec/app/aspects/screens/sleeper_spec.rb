# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Sleeper, :db do
  using Refinements::Pathname

  subject(:sleeper) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }

    it "creates screen" do
      sleeper.call device
      expect(temp_dir.join(device.slug, "sleep.png").exist?).to be(true)
    end

    it "answers output path" do
      expect(sleeper.call(device)).to be_success(temp_dir.join("A1B2C3D4E5F6/sleep.png"))
    end

    context "when screen exists" do
      subject(:sleeper) { described_class.new creator: }

      let(:creator) { instance_spy Terminus::Screens::HTMLSaver }

      before { temp_dir.join(device.slug, "sleep.png").deep_touch }

      it "doesn't create screen" do
        sleeper.call device
        expect(creator).not_to have_received(:call)
      end

      it "answers output path" do
        expect(sleeper.call(device)).to be_success(temp_dir.join("A1B2C3D4E5F6/sleep.png"))
      end
    end
  end
end
