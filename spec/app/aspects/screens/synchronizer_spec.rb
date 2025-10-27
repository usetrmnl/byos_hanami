# frozen_string_literal: true

require "hanami_helper"
require "http"
require "trmnl/api"

RSpec.describe Terminus::Aspects::Screens::Synchronizer, :db do
  subject(:synchronizer) { described_class.new downloader: }

  include_context "with application dependencies"

  let(:model) { Factory[:model, kind: "trmnl", width: 1, height: 1] }
  let(:downloader) { instance_double Terminus::Aspects::Downloader, call: response }

  let :response do
    Success(
      HTTP::Response.new(
        uri: display.image_url,
        verb: :get,
        body: SPEC_ROOT.join("support/fixtures/test.bmp").read,
        status: 200,
        version: 1.0
      )
    )
  end

  let :display do
    TRMNL::API::Models::Display[
      filename: "plugin-2025-05-05T21-20-29Z-e76a5c-1752759373",
      image_url: "https://trmnl.s3.us-east-2.amazonaws.com/n2lw7v67q4fw0g61x1jmvn4qpc04?response" \
                 "-content-disposition=inline%3B%20filename%3D%22plugin-2025-05-05T21-20-29Z-" \
                 "e76a5c%22%3B%20filename%2A%3DUTF-8%27%27plugin-2025-05-05T21-20-29Z-e76a5c" \
                 "\u0026response-content-type=image%2Fbmp\u0026X-Amz-Algorithm=AWS4-HMAC-SHA256" \
                 "\u0026X-Amz-Credential=AKIA47CRUQUU4VKBBMOF%2F20250717%2Fus-east-2%2Fs3%2F" \
                 "aws4_request\u0026X-Amz-Date=20250717T195802Z\u0026X-Amz-Expires=300\u0026" \
                 "X-Amz-SignedHeaders=host\u0026X-Amz-Signature=9ff92f375a626e1073dd26e89" \
                 "e479de3dd1c71b565cb55f26ae4e2195debc670"
    ]
  end

  describe "#call" do
    it "creates new record with attachment" do
      model_repository = instance_spy Terminus::Repositories::Model, find_by: model
      synchronizer = described_class.new(downloader:, model_repository:)
      response = synchronizer.call(display).success

      expect(response).to have_attributes(
        model_id: model.id,
        label: "Plugin E76a5c",
        name: "plugin-e76a5c",
        image_attributes: {
          id: match_md5_checksum(suffix: ".png"),
          metadata: {
            bit_depth: 1,
            checksum: match_md5_checksum,
            filename: "plugin-e76a5c.png",
            height: 1,
            mime_type: "image/png",
            size: kind_of(Integer),
            width: 1
          },
          storage: "store"
        }
      )
    end

    it "updates existing record with new attachment" do
      model
      screen = Factory[:screen, :with_attachment, name: "plugin-e76a5c"]

      response = synchronizer.call(display).success

      expect(response).to have_attributes(
        label: screen.label,
        name: "plugin-e76a5c",
        image_attributes: {
          id: match_md5_checksum(suffix: ".png"),
          metadata: {
            bit_depth: 1,
            checksum: match_md5_checksum,
            filename: "plugin-e76a5c.png",
            height: 1,
            mime_type: "image/png",
            size: kind_of(Integer),
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

    it "answers failure when screen can't be associated with model" do
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
      let(:downloader) { instance_double Terminus::Aspects::Downloader, call: Failure("Danger!") }

      it "answers failure" do
        expect(synchronizer.call(display)).to be_failure("Danger!")
      end
    end
  end
end
