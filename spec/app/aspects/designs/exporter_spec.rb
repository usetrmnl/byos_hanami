# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Designs::Exporter do
  using Refinements::Time

  subject(:exporter) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let :screen_template do
      Factory.structs[:screen_template, label: "Test", name: "test", content: "<h1>Test</h1>"]
    end

    let :proof do
      exporter.call(screen_template)
              .bind { Terminus::Aspects::Unzipper.new.call it }
              .value!
    end

    it "includes index" do
      expect(proof["index.html.liquid"]).to eq("<h1>Test</h1>")
    end

    it "includes configuration" do
      expect(proof["configuration.yml"]).to eq(<<~CONTENT)
        ---
        version: 1.2.3
        label: Test
        name: test
      CONTENT
    end

    it "answers StringIO instance" do
      expect(exporter.call(screen_template)).to match(Success(kind_of(StringIO)))
    end
  end
end
