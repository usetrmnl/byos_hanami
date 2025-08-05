# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Repositories::Screen, :db do
  subject(:repository) { described_class.new }

  let(:screen) { Factory[:screen] }

  describe "#all" do
    it "answers all records" do
      screen
      old = Factory[:screen, updated_at: Time.utc(2025, 1, 1)]

      expect(repository.all).to eq([screen, old])
    end

    it "answers empty array when records don't exist" do
      expect(repository.all).to eq([])
    end
  end

  describe "#all_by" do
    it "answers record for single attribute" do
      expect(repository.all_by(label: screen.label)).to contain_exactly(screen)
    end

    it "answers record for multiple attributes" do
      expect(repository.all_by(label: screen.label, name: screen.name)).to contain_exactly(screen)
    end

    it "answers empty array for unknown value" do
      expect(repository.all_by(label: "bogus")).to eq([])
    end

    it "answers empty array for nil" do
      expect(repository.all_by(label: nil)).to eq([])
    end
  end

  describe "#create_with_image" do
    let(:struct) { Factory.structs[:screen, :with_image] }
    let(:model) { Factory[:model] }

    let :payload do
      Terminus::Aspects::Screens::Creators::Payload[
        model:,
        name: "test",
        label: "Test",
        content: "<p>test</p>"
      ]
    end

    it "answer success when unique" do
      result = repository.create_with_image payload, struct

      expect(result.success).to have_attributes(
        model_id: model.id,
        name: "test",
        label: "Test",
        image_attributes: hash_including(
          metadata: hash_including(
            size: kind_of(Integer),
            width: 1,
            height: 1,
            filename: "test.png",
            mime_type: "image/png"
          )
        )
      )
    end

    context "when existing" do
      let(:struct) { instance_spy Terminus::Structs::Screen }

      before { Factory[:screen, name: "test"] }

      it "destroys image attachment" do
        repository.create_with_image payload, struct
        expect(struct).to have_received(:image_destroy)
      end

      it "answer failure when existing" do
        result = repository.create_with_image payload, struct
        expect(result).to be_failure(%(Screen exists with name: "test".))
      end
    end
  end

  describe "#delete" do
    it "deletes existing record" do
      screen
      repository.delete screen.id

      expect(repository.all).to eq([])
    end

    it "deletes associated image" do
      upload = screen.upload SPEC_ROOT.join("support/fixtures/test.png").open
      repository.update screen.id, image_data: upload.data
      repository.delete screen.id

      expect(Hanami.app[:shrine].storages[:store].store).to eq({})
    end

    it "ignores unknown record" do
      repository.delete 13
      expect(repository.all).to eq([])
    end
  end

  describe "#find" do
    it "answers record by ID" do
      expect(repository.find(screen.id)).to eq(screen)
    end

    it "answers nil for unknown ID" do
      expect(repository.find(13)).to be(nil)
    end

    it "answers nil for nil ID" do
      expect(repository.find(nil)).to be(nil)
    end
  end

  describe "#find_by" do
    it "answers record when found" do
      expect(repository.find_by(name: screen.name)).to eq(screen)
    end

    it "answers record when found by multiple attributes" do
      expect(repository.find_by(name: screen.name, label: screen.label)).to eq(screen)
    end

    it "answers nil when not found" do
      expect(repository.find_by(name: "bogus")).to be(nil)
    end

    it "answers nil for nil" do
      expect(repository.find_by(name: nil)).to be(nil)
    end
  end
end
