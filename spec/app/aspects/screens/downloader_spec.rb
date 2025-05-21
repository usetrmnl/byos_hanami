# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new settings:, client: }

  include_context "with main application"

  let :client do
    SPEC_ROOT.join("support/fixtures/test.png").copy download_path
    instance_double Terminus::Downloader, call: Success(download_path)
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

  let(:download_path) { temp_dir.join path }
  let(:path) { "test/plugin-2025-04-10T11-34-38Z-380c77-1746529676" }
  let(:image_path) { temp_dir.join "test/proxy-380c77.png" }

  describe "#call" do
    before { temp_dir.join("test").mkpath }

    it "downloads file" do
      expect(downloader.call(uri, path)).to be_success(image_path)
    end

    it "answers failure with non-S3 URI" do
      cgi = class_double CGI, parse: CGI.parse("https://trmnl.test/sleep.bmp")
      downloader = described_class.new(settings:, cgi:)

      expect(downloader.call(uri, "test")).to be_failure(%(Invalid image type: "".))
    end

    context "when unable to download" do
      let(:client) { instance_double Terminus::Downloader, call: Failure("Danger!") }

      it "answers failure" do
        expect(downloader.call(uri, "test")).to be_failure("Danger!")
      end
    end
  end
end
