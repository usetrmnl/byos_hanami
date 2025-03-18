# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Helpers do
  subject(:helper) { described_class }

  describe ".human_at" do
    it "answers human date/time" do
      expect(helper.human_at(Time.utc(2025, 1, 2, 3, 4, 5))).to eq("January 02 2025 at 03:04 UTC")
    end
  end
end
