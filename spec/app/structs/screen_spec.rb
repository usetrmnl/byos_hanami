# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Screen, :db do
  subject(:screen) { Factory[:screen] }

  let(:path) { SPEC_ROOT.join "support/fixtures/test.png" }

  before { path.open { |io| screen.upload io } }

  describe "#bit_depth" do
    it "answers bit_depth" do
      screen.attach path.open
      expect(screen.bit_depth).to eq(1)
    end
  end

  describe "#height" do
    it "answers height" do
      screen.attach path.open
      expect(screen.height).to eq(1)
    end
  end

  describe "#image_attributes" do
    it "answers empty attributes without attachment" do
      screen = Factory[:screen]
      expect(screen.image_attributes).to eq({})
    end

    it "answers attributes with attachment" do
      expect(screen.image_attributes).to match(
        id: /\h{32}\.png/,
        metadata: {
          bit_depth: 1,
          filename: "test.png",
          height: 1,
          mime_type: "image/png",
          size: 81,
          width: 1
        },
        storage: "store"
      )
    end
  end

  describe "#image_destroy" do
    it "clears store" do
      id = screen.image_id
      screen.image_destroy

      expect(Hanami.app[:shrine].storages[:store].exists?(id)).to be(false)
    end

    it "clears attributes" do
      screen.image_destroy
      expect(screen.image_attributes).to eq({})
    end
  end

  describe "#image_id" do
    it "answers ID" do
      expect(screen.image_id).to match(/\h{32}/)
    end
  end

  describe "#image_name" do
    it "answers name" do
      expect(screen.image_name).to eq("test.png")
    end
  end

  describe "#image_open" do
    it "yields IO object when given block" do
      screen.image_open { |io| expect(io).to be_a(StringIO) }
    end

    it "answers nil when not given a block" do
      expect(screen.image_open).to be(nil)
    end
  end

  describe "#image_size" do
    it "answers size" do
      expect(screen.image_size).to eq(81)
    end
  end

  describe "#image_type" do
    it "answers MIME type" do
      expect(screen.image_type).to eq("image/png")
    end
  end

  describe "#image_uri" do
    it "answers URI" do
      expect(screen.image_uri).to match(%r(memory://\h{32}\.png))
    end

    it "answers nil when there is no associated image" do
      screen = Factory[:screen]
      expect(screen.image_uri).to be(nil)
    end
  end

  describe "#attach" do
    it "attaches file" do
      expect(screen.attach(path.open).data).to match(
        "id" => /\h{32}\.png/,
        "metadata" => {
          "bit_depth" => 1,
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
          "bit_depth" => nil,
          "filename" => nil,
          "size" => 0,
          "mime_type" => nil,
          "width" => nil,
          "height" => nil
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
          "bit_depth" => 1,
          "filename" => "test.png",
          "height" => 1,
          "size" => 81,
          "mime_type" => "image/png",
          "width" => 1
        },
        "storage" => "store"
      )
    end

    it "updates attributes when valid" do
      screen.upload path.open

      expect(screen.image_attributes).to match(
        id: /\h{32}\.png/,
        storage: "store",
        metadata: {
          bit_depth: 1,
          filename: "test.png",
          size: 81,
          mime_type: "image/png",
          width: 1,
          height: 1
        }
      )
    end

    it "doesn't upload file when invalid" do
      upload = screen.upload StringIO.new

      expect(upload.data).to match(
        "id" => /\h{32}/,
        "metadata" => {
          "bit_depth" => nil,
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

  describe "#width" do
    it "answers width" do
      screen.attach path.open
      expect(screen.width).to eq(1)
    end
  end
end
