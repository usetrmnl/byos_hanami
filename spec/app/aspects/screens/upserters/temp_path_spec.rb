# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Upserters::TempPath, :db do
  using Refinements::Struct

  subject(:creator) { described_class.new }

  include_context "with screen mold"

  describe "#call" do
    let(:model) { Factory[:model] }

    before { mold.with! model_id: model.id }

    it "answers path with specific name and extension (without block)" do
      expect(creator.call(mold).to_s).to match(%r(/test\.png))
    end

    it "answers pathname (without block)" do
      expect(creator.call(mold)).to match(kind_of(Pathname))
    end

    it "answers path with specific name and extension (with block)" do
      capture = nil
      creator.call(mold) { capture = it.to_s }

      expect(capture).to match(%r(/test\.png))
    end

    it "answers pathname (with block)" do
      capture = nil
      creator.call(mold) { capture = it }

      expect(capture).to match(kind_of(Pathname))
    end
  end

  describe "#inspect" do
    it "has inspected attributes" do
      expect(creator.inspect).to match_inspection(sanitizer: "Terminus::Aspects::Sanitizer")
    end
  end
end
