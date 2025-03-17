# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Types do
  using Versionaire::Cast

  describe "Version" do
    subject(:type) { described_class::Version }

    it "answers primitive" do
      expect(type.primitive).to eq(Versionaire::Version)
    end

    it "answers version" do
      expect(type.call("0.0.0")).to eq(Version("0.0.0"))
    end
  end
end
