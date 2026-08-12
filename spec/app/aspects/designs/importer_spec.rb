# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Designs::Importer, :db do
  subject(:creator) { described_class.new }

  describe "#call" do
    let :io do
      manifest = {"configuration.yml" => configuration, "index.html.liquid" => "<h1>Test</h1>"}
      Terminus::Aspects::Zipper.new.call(manifest).value!
    end

    let :configuration do
      <<~CONTENT
        version: 1.2.3
        name: test
        label: Test
      CONTENT
    end

    it "creates screen template" do
      relation = Hanami.app["relations.screen_template"]
      expectation = proc { creator.call io }
      count = proc { relation.count }

      expect(&expectation).to change(&count).by(1)
    end

    it "answers success" do
      expect(creator.call(io)).to match(Success(kind_of(Terminus::Structs::ScreenTemplate)))
    end

    context "with invalid configuration" do
      let(:configuration) { "version: 1.2.3" }

      it "answers failure configuration is missing keys" do
        expect(creator.call(io)).to be_failure("Import name is missing and label is missing.")
      end
    end

    it "answers failure when screen template isn't unique" do
      Factory[:screen_template, name: "test"]

      expect(creator.call(io)).to be_failure(
        %(Name must be unique. Please use a value other than "test".)
      )
    end
  end
end
