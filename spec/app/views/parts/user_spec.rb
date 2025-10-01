# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::User do
  subject(:part) { described_class.new value: user, rendering: view.new.rendering }

  let(:user) { Factory.structs[:user, status_id: 1] }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#pill" do
    it "answers warning when unverified" do
      expect(part.pill).to eq("caution")
    end

    context "with verified status" do
      let(:user) { Factory.structs[:user, status_id: 2] }

      it "answers success" do
        expect(part.pill).to eq("active")
      end
    end

    context "with closed status" do
      let(:user) { Factory.structs[:user, status_id: 3] }

      it "answers failure" do
        expect(part.pill).to eq("inactive")
      end
    end

    context "with invalid status" do
      let(:user) { Factory.structs[:user, status_id: 13] }

      it "answers unknown" do
        expect(part.pill).to eq("unknown")
      end
    end
  end
end
