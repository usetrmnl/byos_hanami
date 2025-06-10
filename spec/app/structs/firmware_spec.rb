# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Structs::Firmware, :db do
  subject :firmware do
    path = temp_dir.join "test.bin"
    path.binwrite [123].pack("N")
    repository.create version: "1.2.3",
                      attachment_data: Hanami.app[:shrine].upload(path.open, :store).data
  end

  let(:repository) { Terminus::Repositories::Firmware.new }

  include_context "with temporary directory"

  describe "#attachment_attributes" do
    it "answers empty attributes without attachment" do
      firmware = Factory[:firmware]
      expect(firmware.attachment_attributes).to eq({})
    end

    it "answers attributes with attachment" do
      update = Hanami.app["repositories.firmware"].create version: "0.0.0", attachment_data: {a: 1}
      expect(update.attachment_attributes).to eq(a: 1)
    end
  end

  describe "#attachment_destroy" do
    it "clears attributes" do
      firmware.attachment_destroy
      expect(firmware.attachment_attributes).to eq({})
    end

    it "clears store" do
      id = firmware.attachment_id
      firmware.attachment_destroy

      expect(Hanami.app[:shrine].storages[:store].exists?(id)).to be(false)
    end
  end

  describe "#attachment_id" do
    it "answers ID" do
      expect(firmware.attachment_id).to match(/\h{32}\.bin/)
    end
  end

  describe "#attachment_name" do
    it "answers name" do
      expect(firmware.attachment_name).to eq("test.bin")
    end
  end

  describe "#attachment_size" do
    it "answers size" do
      expect(firmware.attachment_size).to eq(4)
    end
  end

  describe "#attachment_type" do
    it "answers MIME type" do
      expect(firmware.attachment_type).to eq("application/octet-stream")
    end
  end

  describe "#attachment_uri" do
    it "answers URI" do
      expect(firmware.attachment_uri).to match(%r(memory://\h{32}\.bin))
    end
  end

  describe "#attach" do
    it "attaches file" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")

      upload = firmware.attach path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.bin/,
        "metadata" => {
          "filename" => "test.bin",
          "height" => nil,
          "size" => 4,
          "mime_type" => "application/octet-stream",
          "width" => nil
        },
        "storage" => "cache"
      )
    end
  end

  describe "#upload" do
    it "uploads file when valid" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")

      upload = firmware.upload path.open

      expect(upload.data).to match(
        "id" => /\h{32}\.bin/,
        "metadata" => {
          "filename" => "test.bin",
          "height" => nil,
          "size" => 4,
          "mime_type" => "application/octet-stream",
          "width" => nil
        },
        "storage" => "store"
      )
    end

    it "doesn't upload file when invalid" do
      upload = firmware.upload StringIO.new

      expect(upload.data).to match(
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
      firmware.attach StringIO.new([123].pack("N")), metadata: {"filename" => "test.bin"}
      expect(firmware.errors).to eq([])
    end

    it "answers errors when invalid" do
      firmware.attach StringIO.new

      expect(firmware.errors).to eq(
        [
          "type must be one of: application/octet-stream",
          "extension must be one of: bin"
        ]
      )
    end
  end

  describe "#valid?" do
    it "answers true with no errors" do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")
      firmware.attach path.open

      expect(firmware.valid?).to be(true)
    end

    it "answers false with errors" do
      firmware.attach StringIO.new
      expect(firmware.valid?).to be(false)
    end
  end
end
