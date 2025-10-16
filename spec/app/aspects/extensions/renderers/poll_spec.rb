# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderers::Poll do
  subject(:renderer) { described_class.new fetcher: }

  let(:fetcher) { instance_double Terminus::Aspects::Extensions::MultiFetcher }

  describe ".reduce" do
    let :collection do
      {
        "source_1" => Success("one"),
        "source_2" => Failure("Danger!"),
        "source_3" => Success("three")
      }
    end

    it "reduces collection" do
      expect(described_class.reduce(collection)).to eq(
        "source_1" => "one",
        "source_2" => "Danger!",
        "source_3" => "three"
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
          <h1>{{extension.label}}</h1>
          {% for item in data %}
            <p>{{item.label}}: {{item.description}}</p>
          {% endfor %}
        CONTENT
      ]
    end

    let(:context) { {"extension" => {"label" => "Test Label"}} }

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
      allow(fetcher).to receive(:call).and_return(Success("source_1" => Success(data)))

      expect(renderer.call(extension, context:)).to be_success(
        %(<h1>Test Label</h1>\n\n  <p>Test: A test.</p>\n\n)
      )
    end

    it "renders template with multiple responses" do
      allow(fetcher).to receive(:call).and_return(
        Success(
          {
            "source_1" => Success(data),
            "source_2" => Failure("Danger!"),
            "source_3" => Success(data)
          }
        )
      )

      allow(extension).to receive(:template).and_return(<<~CONTENT)
        <h1>{{extension.label}}</h1>
        {% for item in source_1.data %}<p>{{item.label}}</p>{% endfor %}
        {% for item in source_2.data %}<p>{{item.label}}</p>{% endfor %}
        {% for item in source_3.data %}<p>{{item.label}}</p>{% endfor %}
      CONTENT

      expect(renderer.call(extension, context:)).to be_success(<<~CONTENT)
        <h1>Test Label</h1>
        <p>Test</p>

        <p>Test</p>
      CONTENT
    end
  end
end
