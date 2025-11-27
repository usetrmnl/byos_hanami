# frozen_string_literal: true

require "hanami_helper"
require "json"
require "liquid"

RSpec.describe Terminus::Aspects::Liquid::Filters do
  subject :renderer do
    -> template, data { Liquid::Template.parse(template, environment:).render data }
  end

  let :environment do
    Liquid::Environment.build do |environment|
      environment.error_mode = :strict
      environment.register_filter described_class
    end
  end

  describe "#json" do
    it "answers hash as JSON" do
      content = renderer.call "{{ data | json }}", {"data" => {"name" => "Test", "count" => 42}}
      expect(JSON.parse(content)).to eq("name" => "Test", "count" => 42)
    end

    it "answers array as JSON" do
      content = renderer.call "{{ items | json }}", {"items" => [{"id" => 1}, {"id" => 2}]}
      expect(JSON.parse(content)).to eq([{"id" => 1}, {"id" => 2}])
    end

    it "answers string as JSON" do
      content = renderer.call "{{ str | json }}", {"str" => "string value"}
      expect(JSON(content)).to eq("string value")
    end

    it "answers number as JSON" do
      content = renderer.call "{{ num | json }}", {"num" => 42}
      expect(JSON.parse(content)).to eq(42)
    end

    it "answers nested data" do
      data = {
        "user" => {
          "name" => "Alice",
          "roles" => %w[admin user],
          "metadata" => {"active" => true}
        }
      }

      content = renderer.call "{{user | json}}", data

      expect(JSON(content)).to eq(
        {
          "name" => "Alice",
          "roles" => %w[admin user],
          "metadata" => {"active" => true}
        }
      )
    end

    it "fails when parsing invalid JSON" do
      expectation = proc { renderer.call "{{ data | json }}", "bogus" }
      expect(&expectation).to raise_error(Liquid::ArgumentError, /Expected Hash/)
    end
  end
end
