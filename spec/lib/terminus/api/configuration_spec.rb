# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::API::Configuration do
  subject(:configuration) { described_class.new }

  describe "#initialize" do
    it "answers default attributes" do
      expect(configuration).to eq(
        described_class[api_uri: "https://trmnl.app/api", headers: {accept: "application/json"}]
      )
    end

    it "answers custom attributes" do
      configuration = described_class[
        api_uri: "https://test.io/api",
        headers: {accept: "text/plain"}
      ]

      expect(configuration).to eq(
        described_class[api_uri: "https://test.io/api", headers: {accept: "text/plain"}]
      )
    end
  end
end
