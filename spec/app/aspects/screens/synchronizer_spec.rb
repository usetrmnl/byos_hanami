# frozen_string_literal: true

require "hanami_helper"
require "trmnl/api"

RSpec.describe Terminus::Aspects::Screens::Synchronizer, :db do
  subject(:synchronizer) { described_class.new downloader: }

  include_context "with library dependencies"

  let(:model) { Factory[:model, width: 1, height: 1] }
  let(:downloader) { instance_double Terminus::Downloader, call: response }

  let :response do
    Success(
      HTTP::Response.new(
        uri: display.image_url,
        verb: :get,
        body: SPEC_ROOT.join("support/fixtures/test.png").read,
        status: 200,
        version: 1.0
      )
    )
  end

  let :display do
    TRMNL::API::Models::Display[
      filename: "plugin-1745348489",
      image_url: "https://trmnl.s3.us-east-2.amazonaws.com/abc?" \
                 "response-content-disposition=inline%3B%20filename%3D%22" \
                 "plugin-2025-04-10T11-34-38Z-380c77%22%3B%20filename%2A%3DUTF-8%27%27" \
                 "plugin-2025-04-10T11-34-38Z-380c77\u0026response-content-type=image%2Fpng\u0026" \
                 "X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=ABC%2F20250506%2F" \
                 "us-east-2%2Fs3%2Faws4_request\u0026X-Amz-Date=20250506T153544Z" \
                 "\u0026X-Amz-Expires=300\u0026X-Amz-SignedHeaders=host\u0026" \
                 "X-Amz-Signature=7a11829196fcfb39524d06b746595745520bb9c6f0f098fda2af8c9b7807ece0"
    ]
  end

  describe "#call" do
    it "creates new record with attachment" do
      model
      response = synchronizer.call(display).success

      expect(response).to have_attributes(
        label: "Plugin 1745348489",
        name: "plugin-1745348489.png",
        uri: nil,
        image_attributes: {
          id: /\h{32}\.png/,
          metadata: {
            filename: "plugin-1745348489.png",
            height: 1,
            mime_type: "image/png",
            size: 81,
            width: 1
          },
          storage: "store"
        }
      )
    end

    it "updates existing record with new attachment" do
      model
      screen = Factory[:screen, :with_attachment, name: "plugin-1745348489.png"]

      response = synchronizer.call(display).success

      expect(response).to have_attributes(
        label: screen.label,
        name: "plugin-1745348489.png",
        uri: nil,
        image_attributes: {
          id: /\h{32}\.png/,
          metadata: {
            filename: "plugin-1745348489.png",
            height: 1,
            mime_type: "image/png",
            size: 81,
            width: 1
          },
          storage: "store"
        }
      )
    end

    it "logs error when screen can't be associated with model" do
      synchronizer.call display
      expect(logger.reread).to match(/ERROR.+Unable to find model for screen\./)
    end

    it "answers nil when screen can't be associated with model" do
      expect(synchronizer.call(display)).to be_failure
    end

    context "with non-S3 URI" do
      let :display do
        TRMNL::API::Models::Display[filename: "sleep", image_url: "http://test.io/sleep.bmp"]
      end

      it "answers failure" do
        expect(synchronizer.call(display)).to be_failure("Invalid URL: http://test.io/sleep.bmp.")
      end
    end

    context "with attachment errors" do
      subject(:synchronizer) { described_class.new downloader:, struct: }

      let :struct do
        instance_double Terminus::Structs::Screen, upload: nil, errors: ["Danger!"], valid?: false
      end

      it "answers failure" do
        expect(synchronizer.call(display)).to be_failure(["Danger!"])
      end
    end

    context "with download failure" do
      let(:downloader) { instance_double Terminus::Downloader, call: Failure("Danger!") }

      it "answers failure" do
        expect(synchronizer.call(display)).to be_failure("Danger!")
      end
    end
  end
end
