# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new http:, endpoint: }

  include_context "with library dependencies"
  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  let :endpoint do
    instance_double Terminus::Endpoints::Firmware::Requester,
                    call: Success(
                      Terminus::Endpoints::Firmware::Response[
                        url: "https://trmnl-fw.s3.us-east-2.amazonaws.com/FW1.4.8.bin",
                        version: "1.4.8"
                      ]
                    )
  end

  describe "#call" do
    before { allow(settings).to receive(:firmware_root).and_return temp_dir }

    context "with success" do
      let(:http) { HTTP }

      it "makes root directory if path doesn't exist" do
        downloader.call
        expect(temp_dir.exist?).to be(true)
      end

      it "answers download path" do
        expect(downloader.call).to be_success(temp_dir.join("1.4.8.bin"))
      end
    end

    context "with existing version" do
      let(:http) { HTTP }

      it "answers path" do
        path = temp_dir.join("1.4.8.bin").touch
        expect(downloader.call).to be_success(path)
      end
    end

    context "with endpoint failure" do
      let :endpoint do
        instance_double Terminus::Endpoints::Firmware::Requester, call: Failure(message: "Danger!")
      end

      let(:http) { HTTP }

      it "answers failure when image can't be downloaded" do
        expect(downloader.call).to be_failure(message: "Danger!")
      end
    end

    context "with download failure" do
      let(:http) { class_double HTTP, get: response }

      let :response do
        HTTP::Response.new uri: "https://test.io/test",
                           verb: :get,
                           body: "",
                           status: 404,
                           version: 1.0
      end

      it "answers failure when image can't be downloaded" do
        expect(downloader.call).to be_failure(response)
      end
    end
  end
end
