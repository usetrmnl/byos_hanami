# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Sanitizer do
  subject(:sanitizer) { described_class.new }

  describe "#call" do
    it "allows style element with attributes" do
      element = <<~HTML.strip
        <html><head>
            <style title="Test" type="text/css" media="all">
              * {
                margin: 0;
              }
            </style>
          </head>
          <body>
        </body></html>
      HTML

      expect(sanitizer.call(element)).to eq(element)
    end

    it "allows source element with attributes" do
      source = <<~HTML.squeeze(" ").delete("\n").strip
        <html><head></head>
          <body>
            <source src="https://test.io/one.png"
                    type="image/png"
                    srcset="https://test.io/a-tiny.png 10vw, https://test.io/a-small.png 100vw"
                    sizes="100vw, 10vw"
                    media="(max-width: 600px)"
                    height="10"
                    width="10">
        </body></html>
      HTML

      expect(sanitizer.call(source)).to eq(source)
    end
  end
end
