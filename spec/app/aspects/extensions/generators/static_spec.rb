# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Generators::Static do
  subject(:generator) { described_class.new }

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        kind: "static",
        static_body: {
          "days" => [
            {"label" => "One", "at" => "2025-10-31"},
            {"label" => "Two", "at" => "2026-01-01"}
          ]
        },
        template: <<~BODY
          <h1>{{extension.label}}</h1>
          {% for day in source_1.days %}
            <p>{{day.label}}</p>
          {% endfor %}
        BODY
      ]
    end

    it "answers HTML" do
      data = {"extension" => {"label" => "Days"}}

      expect(generator.call(extension, context: data)).to be_success(<<~CONTENT.strip)
        <html><head></head><body><h1>Days</h1>

          <p>One</p>

          <p>Two</p>

        </body></html>
      CONTENT
    end
  end
end
