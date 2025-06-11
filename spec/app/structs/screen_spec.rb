# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Screen, :db do
  subject(:screen) { Factory[:screen] }

  let(:path) { SPEC_ROOT.join "support/fixtures/test.png" }

  describe "#attachment_attributes" do
    it "answers empty attributes without attachment" do
      expect(screen.attachment_attributes).to eq({})
    end

    it "answers attributes with attachment" do
      update = Hanami.app["repositories.screen"].create label: "Test",
                                                        name: "test",
                                                        attachment: {a: 1}
      expect(update.attachment_attributes).to eq(a: 1)
    end
  end

  describe "#attach" do
    it "attaches file" do
      upload = screen.attach path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.png/,
        "metadata" => {
          "filename" => "test.png",
          "height" => 1,
          "size" => 81,
          "mime_type" => "image/png",
          "width" => 1
        },
        "storage" => "cache"
      )
    end
  end

  describe "#upload" do
    it "uploads file when valid" do
      upload = screen.upload path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.png/,
        "metadata" => {
          "filename" => "test.png",
          "height" => 1,
          "size" => 81,
          "mime_type" => "image/png",
          "width" => 1
        },
        "storage" => "store"
      )
    end

    it "doesn't upload file when invalid" do
      upload = screen.upload StringIO.new

      expect(upload.data).to match(
        "id" => /\h{32}/,
        "metadata" => {
          "filename" => nil,
          "height" => nil,
          "size" => 0,
          "mime_type" => nil,
          "width" => nil
        },
        "storage" => "cache"
      )
    end
  end

  describe "#valid_attachment?" do
    it "answers true with no errors" do
      screen.attach path.open
      expect(screen.valid_attachment?).to be(true)
    end

    it "answers false with errors" do
      screen.attach StringIO.new
      expect(screen.valid_attachment?).to be(false)
    end
  end
end
