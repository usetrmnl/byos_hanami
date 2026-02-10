# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::JSONFormatter do
  subject(:formatter) { described_class }

  describe ".call" do
    it "answers empty string when nil" do
      expect(formatter.call(nil)).to eq("")
    end

    it "pretty prints an array as JSON" do
      data = [1, 2, 3]

      expect(formatter.call(data)).to eq(<<~JSON.strip)
        [
          1,
          2,
          3
        ]
      JSON
    end

    it "pretty prints a hash as JSON" do
      data = {test: [{label: "Test"}]}

      expect(formatter.call(data)).to eq(<<~JSON.strip)
        {
          "test": [
            {
              "label": "Test"
            }
          ]
        }
      JSON
    end

    it "fails for unknown type" do
      expectation = proc { described_class.call Object }
      expect(&expectation).to raise_error(TypeError, "Unknown type to format as JSON for: Object.")
    end
  end
end
