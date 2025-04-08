# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::LibContainer do
  subject(:container) { described_class }

  describe ".[]" do
    it "answers HTTP" do
      expect(container[:http]).to eq(HTTP)
    end
  end
end
