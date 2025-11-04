# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Jobs::ExtensionScreen, :db do
  subject(:job) { described_class.new }

  describe "#perform" do
    let :extension do
      Factory[
        :extension,
        name: "test",
        label: "Test",
        kind: "static",
        body: {"name" => "Test"},
        template: "<p>{{name}}</p>"
      ]
    end

    let(:model) { Factory[:model] }

    it "creates screen" do
      result = job.perform extension.id, model.id

      expect(result.success).to have_attributes(
        name: "extension-test",
        label: "Extension Test",
        image_attributes: hash_including(
          id: kind_of(String),
          metadata: kind_of(Hash),
          storage: "store"
        )
      )
    end

    it "answers success when extension and model exist" do
      result = job.perform extension.id, model.id
      expect(result).to match(Success(kind_of(Terminus::Structs::Screen)))
    end

    it "answers failure when extension can't be found" do
      result = job.perform 13, model.id
      expect(result).to be_failure("Unable to find by extension ID: 13.")
    end
  end
end
