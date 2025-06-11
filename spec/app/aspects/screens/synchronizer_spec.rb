# frozen_string_literal: true

require "hanami_helper"
require "trmnl/api"

RSpec.describe Terminus::Aspects::Screens::Synchronizer, :db do
  subject(:synchronizer) { described_class.new downloader: }

  let(:downloader) { instance_double Terminus::Downloader, call: response }

  let :response do
    Success(
      HTTP::Response.new(
        uri: "https://trmnl-fw.s3.us-east-2.amazonaws.com/FW1.2.3.bin",
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
      firmware_url: "https://trmnl-fw.s3.us-east-2.amazonaws.com/FW1.4.8.bin",
      image_url: uri,
      image_url_timeout: 0,
      refresh_rate: 1771,
      reset_firmware: false,
      special_function: "restart_playlist",
      update_firmware: true
    ]
  end

  let :uri do
    "https://trmnl.s3.us-east-2.amazonaws.com/abc?" \
    "response-content-disposition=inline%3B%20filename%3D%22" \
    "plugin-2025-04-10T11-34-38Z-380c77%22%3B%20filename%2A%3DUTF-8%27%27" \
    "plugin-2025-04-10T11-34-38Z-380c77\u0026response-content-type=image%2Fpng\u0026" \
    "X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=ABC%2F20250506%2F" \
    "us-east-2%2Fs3%2Faws4_request\u0026X-Amz-Date=20250506T153544Z\u0026X-Amz-Expires=300\u0026" \
    "X-Amz-SignedHeaders=host\u0026" \
    "X-Amz-Signature=7a11829196fcfb39524d06b746595745520bb9c6f0f098fda2af8c9b7807ece0"
  end

  describe "#call" do
    it "downloads file" do
      response = synchronizer.call(display).success

      expect(response).to have_attributes(
        label: "plugin-1745348489.png",
        name: "plugin-1745348489.png",
        uri: nil,
        attachment_attributes: {
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

    it "answers record when it already exists" do
      screen = Factory[:screen, name: "plugin-1745348489.png"]
      expect(synchronizer.call(display)).to be_success(screen)
    end

    it "answers failure with non-S3 URI" do
      cgi = class_double CGI, parse: CGI.parse("https://trmnl.test/sleep.bmp")
      synchronizer = described_class.new(downloader:, cgi:)

      expect(synchronizer.call(display)).to be_failure(["extension must be one of: bmp, png"])
    end

    context "when unable to download" do
      let(:downloader) { instance_double Terminus::Downloader, call: Failure("Danger!") }

      it "answers failure" do
        expect(synchronizer.call(display)).to be_failure("Danger!")
      end
    end
  end
end
