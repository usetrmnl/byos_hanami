# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Coercers::Empty do
  subject(:coercer) { described_class }

  let(:attributes) { {days: %w[monday friday]} }

  let :result do
    Dry::Schema::Result.new(attributes, message_compiler: proc { Hash.new }, result_ast: [])
  end

  describe "#call" do
    it "answers array when key is present" do
      expect(coercer.call(:days, result)).to eq(days: %w[monday friday])
    end

    it "answers key with empty value (default) when key is missing" do
      attributes.clear
      expect(coercer.call(:days, result)).to eq(days: [])
    end

    it "answers key with empty value (custom) when key is missing" do
      attributes.clear
      expect(coercer.call(:days, result, {})).to eq(days: {})
    end
  end
end
