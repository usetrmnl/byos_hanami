# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Downloader do
  using Refinements::Pathname

  subject(:downloader) { described_class.new http: }

  include_context "with library dependencies"
  include_context "with temporary directory"

  let(:http) { class_double HTTP, get: response }

  let :response do
    HTTP::Response.new uri: "https://test.io", verb: :get, body: "Test.", status: 200, version: 1.0
  end

  describe "#call" do
    let(:uri) { "https://test.io" }
    let(:path) { temp_dir.join "downloads/test.txt" }

    it "makes root directory if path doesn't exist" do
      downloader.call uri, path
      expect(temp_dir.join("downloads").exist?).to be(true)
    end

    it "downloads content" do
      downloader.call uri, path
      expect(path.read).to eq("Test.")
    end

    it "doesn't download content when path exists" do
      path.make_ancestors.write "Original."
      downloader.call uri, path

      expect(path.read).to eq("Original.")
    end

    it "answers path" do
      expect(downloader.call(uri, path)).to be_success(path)
    end

    it "logs info" do
      downloader.call uri, path
      expect(logger.reread).to match(/INFO.+Downloaded: #{path}\./)
    end

    context "with download failure" do
      let(:http) { class_double HTTP, get: response }

      let :response do
        HTTP::Response.new uri: "https://test.io",
                           verb: :get,
                           body: "Danger!",
                           status: 404,
                           version: 1.0
      end

      it "answers failure when image can't be downloaded" do
        expect(downloader.call(uri, path)).to be_failure(response)
      end

      it "logs error" do
        downloader.call uri, path
        expect(logger.reread).to match(/ERROR.+Danger!/)
      end
    end

    context "with SSL error" do
      before { allow(http).to receive(:get).and_raise(OpenSSL::SSL::SSLError, "Danger!") }

      it "answers failure" do
        expect(downloader.call("https://test.io", path)).to be_failure("Danger!")
      end

      it "logs error" do
        downloader.call uri, path
        expect(logger.reread).to match(/ERROR.+Danger!/)
      end
    end

    it "logs error due to inability to perform download" do
      allow(response).to receive(:then).and_return(Failure(:danger))
      downloader.call uri, path

      expect(logger.reread).to match(/ERROR.+Unable to perform download/)
    end
  end
end
