# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Model do
  subject(:model) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(model).to have_attributes(
        path: nil, size: 0, uri: nil, version: nil, modified_at: instance_of(Time)
      )
    end
  end
end
