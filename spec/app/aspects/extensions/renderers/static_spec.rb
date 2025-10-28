# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderers::Static do
  subject(:renderer) { described_class.new }

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        kind: "static",
        body: {
          "holidays" => [
            {"label" => "Halloween", "at" => "2025-10-31"},
            {"label" => "New Years", "at" => "2026-01-01"}
          ]
        },
        template: <<~BODY
          {% for holiday in holidays %}
            <p>{{holiday.label}} ({{holiday.label}})</p>
          {% endfor %}
        BODY
      ]
    end

    it "renders template" do
      expect(renderer.call(extension)).to be_success(
        %(\n  <p>Halloween (Halloween)</p>\n\n  <p>New Years (New Years)</p>\n\n)
      )
    end
  end
end
