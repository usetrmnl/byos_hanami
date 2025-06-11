# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Screen, :db do
  subject(:screen) { Factory[:screen, :with_image] }

  let(:path) { SPEC_ROOT.join "support/fixtures/test.png" }

  describe "#image_attributes" do
    it "answers empty attributes without attachment" do
      screen = Factory[:screen]
      expect(screen.image_attributes).to eq({})
    end

    it "answers attributes with attachment" do
      expect(screen.image_attributes).to eq(
        id: "abc123.png",
        metadata: {
          filename: "test.png",
          height: 1,
          mime_type: "image/png",
          size: 1,
          width: 1
        },
        storage: "store"
      )
    end
  end

  describe "#image_id" do
    it "answers ID" do
      expect(screen.image_id).to match("abc123.png")
    end
  end

  describe "#attach" do
    it "attaches file" do
      expect(screen.attach(path.open).data).to match(
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

    it "doesn't attach when invalid" do
      expect(screen.attach(StringIO.new).data).to match(
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

  describe "#finalize" do
    it "finalizes attachment when valid" do
      screen.attach path.open

      expect(screen.finalize.data).to match(
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

    it "doesn't finalize attachment when invalid" do
      screen.attach StringIO.new

      expect(screen.finalize.data).to match(
        "id" => /\h{32}/,
        "metadata" => {
          "filename" => nil,
          "height" => nil,
          "size" => 0,
          "mime_type" => nil,
          "width" => nil
        },
        "storage" => "store"
      )
    end
  end

  describe "#errors" do
    it "answers empty array when valid" do
      screen.attach path.open
      expect(screen.errors).to eq([])
    end

    it "answers errors when invalid" do
      screen.attach StringIO.new

      expect(screen.errors).to eq(
        [
          "type must be one of: image/bmp, image/png",
          "extension must be one of: bmp, png"
        ]
      )
    end
  end

  describe "#valid?" do
    it "answers true with no errors" do
      screen.attach path.open
      expect(screen.valid?).to be(true)
    end

    it "answers false with errors" do
      screen.attach StringIO.new
      expect(screen.valid?).to be(false)
    end
  end
end
