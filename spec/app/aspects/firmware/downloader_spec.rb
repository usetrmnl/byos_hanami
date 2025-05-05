# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Firmware::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new endpoint: }

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
    let(:path) { temp_dir.join "1.5.2.bin" }

    it "answers download path" do
      expect(downloader.call).to be_success(path)
    end

    it "answers existing path" do
      path.touch
      expect(downloader.call).to be_success(path)
    end

    context "with endpoint failure" do
      let :endpoint do
        instance_double TRMNL::API::Endpoints::Firmware, call: Failure(message: "Danger!")
      end

      it "answers failure when image can't be downloaded" do
        expect(downloader.call).to be_failure(message: "Danger!")
      end
    end
  end
end
