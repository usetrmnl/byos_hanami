# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Model do
  subject(:model) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(model).to have_attributes(path: nil, uri: nil, version: nil)
    end
  end
end
