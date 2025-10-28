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
          <h1>{{extension.label}}</h1>
          {% for holiday in holidays %}
            <p>{{holiday.label}} ({{holiday.label}})</p>
          {% endfor %}
        BODY
      ]
    end

    it "renders template" do
      context = {"extension" => {"label" => "Holidays"}}

      expect(renderer.call(extension, context:)).to be_success(
        %(<h1>Holidays</h1>\n\n  <p>Halloween (Halloween)</p>\n\n  <p>New Years (New Years)</p>\n\n)
      )
    end
  end
end
