# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderers::Poll do
  subject(:renderer) { described_class.new fetcher: }

  let(:fetcher) { instance_double Terminus::Aspects::Extensions::MultiFetcher }

  describe ".reduce" do
    let(:collection) { {"0" => Success("one"), "1" => Failure("Danger!"), "2" => Success("two")} }

    it "reduces collection" do
      expect(described_class.reduce(collection)).to eq(
        "0" => "one",
        "1" => "Danger!",
        "2" => "two"
      )
    end

    it "mutates collection" do
      expect(described_class.reduce(collection.dup)).not_to eq(collection)
    end
  end

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        kind: "poll",
        uris: ["https://test.io/test.json"],
        template: <<~CONTENT
          {% for item in data %}
            <p>{{item.label}}: {{item.description}}</p>
          {% endfor %}
        CONTENT
      ]
    end

    let :data do
      {
        "data" => [
          {
            "label" => "Test",
            "description" => "A test."
          }
        ]
      }
    end

    it "renders template with single response" do
      allow(fetcher).to receive(:call).and_return(Success("0" => Success(data)))
      expect(renderer.call(extension)).to be_success(%(\n  <p>Test: A test.</p>\n\n))
    end

    it "renders template with multiple responses" do
      allow(fetcher).to receive(:call).and_return(
        Success(
          {
            "0" => Success(data),
            "1" => Failure("Danger!"),
            "2" => Success(data)
          }
        )
      )

      allow(extension).to receive(:template).and_return(<<~CONTENT)
        {% for item in 0.data %}<p>{{item.label}}</p>{% endfor %}
        {% for item in 1.data %}<p>{{item.label}}</p>{% endfor %}
        {% for item in 2.data %}<p>{{item.label}}</p>{% endfor %}
      CONTENT

      expect(renderer.call(extension)).to be_success(<<~CONTENT)
        <p>Test</p>

        <p>Test</p>
      CONTENT
    end
  end
end
