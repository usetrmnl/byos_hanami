# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Creators::TempPath, :db do
  subject(:saver) { described_class.new }

  describe "#call" do
    let(:model) { Factory[:model] }

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

    let :payload do
      Terminus::Aspects::Screens::Creators::Payload[model:, name: "test", label: "Test", content:]
    end

    it "answers path with specific name and extension (without block)" do
      expect(saver.call(payload).to_s).to match(%r(/test\.png))
    end

    it "answers pathname (without block)" do
      expect(saver.call(payload)).to match(kind_of(Pathname))
    end

    it "answers path with specific name and extension (with block)" do
      capture = nil
      saver.call(payload) { capture = it.to_s }

      expect(capture).to match(%r(/test\.png))
    end

    it "answers pathname (with block)" do
      capture = nil
      saver.call(payload) { capture = it }

      expect(capture).to match(kind_of(Pathname))
    end
  end

  describe "#inspect" do
    it "only displays the sanitizer class" do
      expect(saver.inspect).to include("@sanitizer=Terminus::Sanitizer")
    end
  end
end
