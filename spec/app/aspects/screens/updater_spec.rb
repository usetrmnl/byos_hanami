# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Updater, :db do
  subject(:updater) { described_class.new }

  include_context "with temporary directory"

  describe "#call" do
    let(:model) { Factory[:model] }
    let(:screen) { Factory[:screen, :with_image, model_id: model.id] }
    let(:fixture_path) { SPEC_ROOT.join "support/fixtures/test.png" }

    it "updates screen with HTML content" do
      result = updater.call screen, content: "<h1>Updated</h1>"

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: screen.name,
        label: screen.label,
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "#{screen.name}.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "updates screen with Base64 encoded data" do
      data = Base64.strict_encode64 fixture_path.read
      result = updater.call screen, data: data

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: screen.name,
        label: screen.label,
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "#{screen.name}.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "updates screen with preprocessed URI" do
      result = updater.call screen, uri: fixture_path.to_s, preprocessed: true

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: screen.name,
        label: screen.label,
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 1,
            height: 1,
            filename: "#{screen.name}.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "updates screen with unprocessed URI" do
      result = updater.call screen, uri: fixture_path.to_s

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: screen.name,
        label: screen.label,
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 800,
            height: 480,
            filename: "#{screen.name}.png",
            mime_type: "image/png"
          )
        )
      )
    end

    it "updates screen attributes without image" do
      result = updater.call screen, label: "New Label"

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: screen.name,
        label: "New Label"
      )
    end

    it "answers failure for invalid model ID with content" do
      expect(updater.call(screen, model_id: 666, content: "<p>Test</p>")).to be_failure(
        "Unable to find model for ID: 666."
      )
    end

    it "answers failure for invalid model ID with data" do
      data = Base64.strict_encode64 fixture_path.read

      expect(updater.call(screen, model_id: 666, data: data)).to be_failure(
        "Unable to find model for ID: 666."
      )
    end

    it "answers failure for invalid model ID with uri" do
      expect(updater.call(screen, model_id: 666, uri: fixture_path.to_s)).to be_failure(
        "Unable to find model for ID: 666."
      )
    end

    it "answers failure for invalid Base64 data" do
      expect(updater.call(screen, data: "invalid-base64-data!!!").failure).to match(
        /Invalid Base64 data/
      )
    end

    it "answers failure for invalid URI" do
      expect(updater.call(screen, uri: "/nonexistent/path.png").failure).to match(
        /Unable to fetch image/
      )
    end
  end
end
