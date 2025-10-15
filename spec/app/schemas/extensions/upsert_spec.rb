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
        mode: "light",
        tags: "one,two,three",
        headers: %({"Accept": "application/json"}),
        verb: "get",
        uri: "https://test.io",
        poll_body: %({"sort_by": "name"}),
        static_body: %({"name": "test"}),
        fields: %({"name": "test"}),
        padding: "on",
        template_full: "A full test.",
        template_horizontal: "A horizontal test.",
        template_vertical: "A veritcal test.",
        template_quarter: "A quarter test.",
        template_shared: "A shared test.",
        repeat_interval: 1,
        repeat_type: "day",
        repeat_days: "monday,friday",
        last_day_of_month: "on"
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

    it "answers pull body hash" do
      expect(contract.call(attributes).to_h).to include(poll_body: {"sort_by" => "name"})
    end

    it "answers static body hash" do
      expect(contract.call(attributes).to_h).to include(static_body: {"name" => "test"})
    end

    it "answers fields hash" do
      expect(contract.call(attributes).to_h).to include(fields: {"name" => "test"})
    end

    it "answers true when padding is truthy" do
      expect(contract.call(attributes).to_h).to include(padding: true)
    end

    it "answers false when padding key is missing" do
      attributes.delete :padding
      expect(contract.call(attributes).to_h).to include(padding: false)
    end

    it "answers failure when repeat interval is less than zero" do
      attributes[:repeat_interval] = -1

      expect(contract.call(attributes).errors.to_h).to include(
        repeat_interval: ["must be greater than or equal to 0"]
      )
    end

    it "answers repeat days array" do
      expect(contract.call(attributes).to_h).to include(repeat_days: %w[monday friday])
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
