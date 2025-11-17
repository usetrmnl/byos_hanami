# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Jobs::Batches::Extension, :db do
  subject(:job) { described_class.new }

  describe "#perform" do
    let(:extension) { Factory[:extension] }
    let(:model) { Factory[:model] }

    before { Terminus::Repositories::Extension.new.update_with_models extension.id, {}, [model.id] }

    it "creates screen" do
      result = job.perform extension.id
      expect(result).to be_success("Enqueued jobs for extension: #{extension.id}.")
    end

    it "answers failure when extension can't be found" do
      result = job.perform 13
      expect(result).to be_failure("Unable to enqueue jobs for extension: 13.")
    end
  end
end
