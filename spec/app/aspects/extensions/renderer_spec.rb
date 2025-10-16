# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderer do
  subject(:renderer) { described_class.new }

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        label: "Test",
        name: "test",
        kind: "poll",
        mode: "light",
        headers: {"Accept" => "application/json", "Accept-Encoding" => "deflate,gzip"},
        verb: "get",
        uris: "https://alchemists.io/api/alfred/projects.json",
        repeat_type: "day",
        template_full: <<~CONTENT
          {% for item in items limit:8 %}
            <p id="{{forloop.index}}">{{item.label}}: {{item.description}}</p>
          {% else %}
            <p>No projects found.</p>
          {% endfor %}
        CONTENT
      ]
    end

    let :data do
      {
        "items" => [
          {
            "label" => "One",
            "description" => "First test."
          },
          {
            "label" => "Two",
            "description" => "Second test."
          }
        ]
      }
    end

    it "renders template" do
      expect(renderer.call(extension, data)).to include(
        %(<p id="1">One: First test.</p>\n\n  <p id="2">Two: Second test.</p>)
      )
    end
  end
end
