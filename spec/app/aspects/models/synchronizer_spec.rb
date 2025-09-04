# frozen_string_literal: true

require "hanami_helper"
require "trmnl/api"

RSpec.describe Terminus::Aspects::Models::Synchronizer, :db do
  subject(:synchronizer) { described_class.new trmnl_api: }

  let :trmnl_api do
    instance_double TRMNL::API::Client,
                    models: Success(
                      [
                        TRMNL::API::Models::Model[
                          name: "test",
                          label: "Test",
                          description: "A test.",
                          colors: 3,
                          bit_depth: 5,
                          rotation: 90,
                          mime_type: "image/png",
                          width: 800,
                          height: 480,
                          offset_x: 10,
                          offset_y: 15,
                          published_at: "2025-01-01 00:00:00 UTC"
                        ]
                      ]
                    )
  end

  let(:repository) { Terminus::Repositories::Model.new }

  describe "#call" do
    context "with no remote models" do
      let(:trmnl_api) { instance_double TRMNL::API::Client, models: Success([]) }

      it "deletes core records" do
        Factory[:model, name: "test", kind: "core"]
        synchronizer.call
        repository.all

        expect(repository.all).to eq([])
      end
    end

    it "creates new record when missing" do
      synchronizer.call
      record = repository.all.first

      expect(record).to have_attributes(
        name: "test",
        label: "Test",
        description: "A test.",
        kind: "core",
        colors: 3,
        bit_depth: 5,
        rotation: 90,
        mime_type: "image/png",
        width: 800,
        height: 480,
        offset_x: 10,
        offset_y: 15,
        published_at: Time.parse("2025-01-01 00:00:00 UTC")
      )
    end

    it "updates existing record" do
      Factory[:model, name: "test", kind: "core"]
      synchronizer.call
      record = repository.all.first

      expect(record).to have_attributes(
        name: "test",
        label: "Test",
        description: "A test.",
        kind: "core",
        colors: 3,
        bit_depth: 5,
        rotation: 90,
        mime_type: "image/png",
        width: 800,
        height: 480,
        offset_x: 10,
        offset_y: 15,
        published_at: Time.parse("2025-01-01 00:00:00 UTC")
      )
    end

    it "answers failure when models can't be obtained" do
      trmnl_api = instance_spy TRMNL::API::Client, models: Failure("Danger!")
      synchronizer = described_class.new(trmnl_api:)

      expect(synchronizer.call).to be_failure("Danger!")
    end
  end
end
