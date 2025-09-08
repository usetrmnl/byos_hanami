# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Relations::Firmware, :db do
  subject(:relation) { Hanami.app["relations.firmware"] }

  describe "#by_version_desc" do
    it "orders by descending version" do
      one = Factory[:firmware, version: "0.0.1"]
      ten = Factory[:firmware, version: "0.0.10"]
      five = Factory[:firmware, version: "0.0.5"]

      expect(relation.by_version_desc.to_a).to eq([ten, five, one].map(&:to_h))
    end
  end
end
