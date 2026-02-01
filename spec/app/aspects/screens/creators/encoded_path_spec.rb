# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::EncodedPath, :db do
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with screen mold"

  describe "#call" do
    let(:model) { Factory[:model] }

    before do
      mold.with! model_id: model.id,
                 content: Base64.strict_encode64(SPEC_ROOT.join("support/fixtures/test.png").read)
    end

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

    context "with invalid Base64 data" do
      before { mold.with! content: "invalid-base64-data!!!" }

      it "answers failure" do
        expect(creator.call(mold)).to be_failure
      end

      it "answers failure message" do
        expect(creator.call(mold).failure).to match(/Invalid Base64 data/)
      end
    end
  end
end
