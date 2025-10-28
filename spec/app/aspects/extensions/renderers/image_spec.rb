# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Renderers::Image do
  subject(:renderer) { described_class.new }

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        kind: "image",
        uris: ["https://test.io/test.png"],
        template: %(<img src="{{url}}" alt="{{extension.alt}}">)
      ]
    end

    let(:context) { {"extension" => {"alt" => "Image"}} }

    it "renders template with single URI" do
      expect(renderer.call(extension, context:)).to be_success(
        %(<img src="https://test.io/test.png" alt="Image">)
      )
    end

    it "renders template with multipe URIs" do
      extension.uris.replace ["https://test.io/one.png", "https://test.io/two.png"]

      allow(extension).to receive(:template).and_return(<<~CONTENT)
        <img src="{{source_1.url}}" alt="{{extension.alt}}">
        <img src="{{source_2.url}}" alt="{{extension.alt}}">
      CONTENT

      expect(renderer.call(extension, context:)).to be_success(<<~CONTENT)
        <img src="https://test.io/one.png" alt="Image">
        <img src="https://test.io/two.png" alt="Image">
      CONTENT
    end
  end
end
