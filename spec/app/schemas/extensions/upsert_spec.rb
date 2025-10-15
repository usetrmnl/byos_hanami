# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Schemas::Extensions::Upsert do
  subject(:contract) { described_class }

  describe "#call" do
    let :attributes do
      {
        name: "test",
        label: "Test",
        description: "A test.",
        kind: "pull",
        tags: "one,two,three",
        headers: %({"Accept": "application/json"}),
        verb: "get",
        uris: "https://one.io,https://two.io",
        body: %({"test": "example"}),
        template: "A full test.",
        data: %({"label": "Test"}),
        interval: 1,
        unit: "day",
        days: %w[monday friday],
        last_day_of_month: "on",
        start_at: "2025-01-01T00:00:00"
      }
    end

    it "answers success when all attributes are valid" do
      expect(contract.call(attributes).to_monad).to be_success
    end

    it "answers tags array" do
      expect(contract.call(attributes).to_h).to include(tags: %w[one two three])
    end

    it "answers headers hash" do
      expect(contract.call(attributes).to_h).to include(headers: {"Accept" => "application/json"})
    end

    it "answers uris array" do
      expect(contract.call(attributes).to_h).to include(uris: %w[https://one.io https://two.io])
    end

    it "answers body hash" do
      expect(contract.call(attributes).to_h).to include(body: {"test" => "example"})
    end

    it "answers data hash" do
      expect(contract.call(attributes).to_h).to include(data: {"label" => "Test"})
    end

    it "answers failure when repeat interval is less than zero" do
      attributes[:interval] = -1

      expect(contract.call(attributes).errors.to_h).to include(
        interval: ["must be greater than or equal to 0"]
      )
    end

    it "answers true when last day of month is truthy" do
      expect(contract.call(attributes).to_h).to include(last_day_of_month: true)
    end

    it "answers false when last day of month key is missing" do
      attributes.delete :last_day_of_month
      expect(contract.call(attributes).to_h).to include(last_day_of_month: false)
    end
  end
end
