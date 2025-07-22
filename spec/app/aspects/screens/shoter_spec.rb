# frozen_string_literal: true

require "hanami_helper"
require "mini_magick"

RSpec.describe Terminus::Aspects::Screens::Shoter do
  subject(:screensaver) { described_class.new }

  include_context "with temporary directory"

  describe "#call" do
    let :content do
      <<~CONTENT
        <html>
          <head>
            <style>
              color: black;
              background-color: black;
            </style>
          </head>

          <body>
            <h1>Test</h1>
          </body>
        </html>
      CONTENT
    end

    let(:path) { temp_dir.join "test.jpeg" }

    it "creates screenshot" do
      screensaver.call content, path
      image = MiniMagick::Image.open path

      expect(image).to have_attributes(width: 800, height: 480, type: "JPEG", exif: {})
    end

    it "answers image path" do
      expect(screensaver.call(content, path)).to be_success(path)
    end
  end
end
