# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::ExtensionExchange do
  subject :exchange do
    Factory.structs[
      :extension_exchange,
      headers: {"accept" => "application/json"},
      body: {"query" => "test"},
      template: "https://test.io"
    ]
  end

  describe "#export_attributes" do
    it "answers attributes" do
      expect(exchange.export_attributes).to eq(
        headers: {"accept" => "application/json"},
        verb: "get",
        body: {"query" => "test"},
        template: "https://test.io"
      )
    end
  end
end
