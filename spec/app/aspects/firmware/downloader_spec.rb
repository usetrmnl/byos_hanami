# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new http:, endpoint: }

  include_context "with main application"
  include_context "with library dependencies"

  let(:http) { HTTP }

  let :endpoint do
    instance_double TRMNL::API::Endpoints::Firmware,
                    call: Success(
                      TRMNL::API::Models::Firmware[
                        url: "https://trmnl-fw.s3.us-east-2.amazonaws.com/FW1.5.2.bin",
                        version: "1.5.2"
                      ]
                    )
  end

  describe "#call" do
    it "makes root directory if path doesn't exist" do
      downloader.call
      expect(temp_dir.exist?).to be(true)
    end

    it "answers download path" do
      expect(downloader.call).to be_success(temp_dir.join("1.5.2.bin"))
    end

    context "with existing version" do
      it "answers path" do
        path = temp_dir.join("1.5.2.bin").touch
        expect(downloader.call).to be_success(path)
      end
    end

    context "with endpoint failure" do
      let :endpoint do
        instance_double TRMNL::API::Endpoints::Firmware, call: Failure(message: "Danger!")
      end

      it "answers failure when image can't be downloaded" do
        expect(downloader.call).to be_failure(message: "Danger!")
      end
    end

    context "with download failure" do
      let(:http) { class_double HTTP, get: response }

      let :response do
        HTTP::Response.new uri: "https://test.io/test",
                           verb: :get,
                           body: "Danger!",
                           status: 404,
                           version: 1.0
      end

      it "answers failure when image can't be downloaded" do
        expect(downloader.call).to be_failure("Danger!")
      end
    end

    it "answers failure with SSL error" do
      allow(http).to receive(:get).and_raise(OpenSSL::SSL::SSLError, "Danger!")
      expect(downloader.call).to be_failure("Danger!")
    end
  end
end
