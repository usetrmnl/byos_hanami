# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Savers::HTML, :db do
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
      Terminus::Aspects::Screens::Savers::Payload[model:, name: "test", label: "Test", content:]
    end

    it "answers screen" do
      result = saver.call payload

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "test",
        label: "Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "test.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "answers failure with database error" do
      result = saver.call payload.with(name: nil)
      expect(result.failure).to match(/null value/)
    end
  end

  describe "#inspect" do
    it "only displays the sanitizer class" do
      expect(saver.inspect).to include("@sanitizer=Terminus::Sanitizer")
    end
  end
end
