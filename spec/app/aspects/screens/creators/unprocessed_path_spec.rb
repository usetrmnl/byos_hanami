# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::UnprocessedPath, :db do
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with screen mold"

  describe "#call" do
    let(:model) { Factory[:model] }
    let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.png" }

    before { mold.with! model_id: model.id, content: fixture_path.to_s }

    it "answers path with specific name and extension (without block)" do
      expect(creator.call(mold).to_s).to match(%r(/test\.png))
    end

    it "answers pathname (without block)" do
      expect(creator.call(mold)).to be_a(Pathname)
    end

    it "answers path with specific name and extension (with block)" do
      capture = nil
      creator.call(mold) { capture = it.to_s }

      expect(capture).to match(%r(/test\.png))
    end

    it "answers pathname (with block)" do
      capture = nil
      creator.call(mold) { capture = it }

      expect(capture).to be_a(Pathname)
    end

    context "with invalid URI" do
      before { mold.with! content: "/nonexistent/path.png" }

      it "answers failure" do
        expect(creator.call(mold)).to be_failure
      end

      it "answers failure message" do
        expect(creator.call(mold).failure).to match(/Unable to fetch image/)
      end
    end
  end
end
