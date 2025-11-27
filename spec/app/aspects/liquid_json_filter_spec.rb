# frozen_string_literal: true

require "json"
require "liquid"
require "spec_helper"

RSpec.describe Terminus::Aspects::LiquidJSONFilter do
  let(:template_data) { {"data" => {"name" => "Test", "count" => 42}} }
  let(:template_body) { "{{ data | json }}" }

  context "without custom json filter" do
    let(:environment) { Liquid::Environment.build { it.error_mode = :strict } }

    it "renders Ruby hash syntax, not valid JSON" do
      template = Liquid::Template.parse(template_body, environment:)
      result = template.render template_data
      expect { JSON.parse(result) }
        .to raise_error(JSON::ParserError)
    end
  end

  context "with liquid json filter" do
    let :environment do
      Liquid::Environment.build do |env|
        env.error_mode = :strict
        env.register_filter described_class
      end
    end

    it "converts Ruby hash to valid JSON string" do
      template = Liquid::Template.parse(template_body, environment:)

      result = template.render template_data

      expect(JSON.parse(result)).to eq(template_data["data"])
    end

    it "converts Ruby array to valid JSON string" do
      template = Liquid::Template.parse("{{ items | json }}", environment:)
      data = {"items" => [{"id" => 1}, {"id" => 2}]}

      result = template.render data

      expect(JSON.parse(result)).to eq([{"id" => 1}, {"id" => 2}])
    end

    it "handles nested data structures" do
      template = Liquid::Template.parse("{{ user | json }}", environment:)
      data = {
        "user" => {
          "name" => "Alice",
          "roles" => %w[admin user],
          "metadata" => {"active" => true}
        }
      }

      result = template.render data
      parsed = JSON.parse result

      expect(parsed).to eq(
        {
          "name" => "Alice",
          "roles" => %w[admin user],
          "metadata" => {"active" => true}
        }
      )
    end
  end
end
