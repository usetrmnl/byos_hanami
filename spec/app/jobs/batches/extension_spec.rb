# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Jobs::Batches::Extension, :db do
  subject(:job) { described_class.new }

  describe "#perform" do
    let(:repository) { Terminus::Repositories::Extension.new }
    let(:extension) { Factory[:extension] }
    let(:model) { Factory[:model] }

    context "with models" do
      let(:model) { Factory[:model] }

      before { repository.update_with_models extension.id, {}, [model.id] }

      it "enqueues delegate job" do
        result = job.perform extension.id
        expect(result).to be_success("Enqueued jobs for extension: #{extension.id}.")
      end

      it "answers failure when extension can't be found" do
        result = job.perform 666
        expect(result).to be_failure("Unable to enqueue jobs for extension: 666.")
      end
    end

    context "with devices" do
      let(:device) { Factory[:device] }

      before { repository.update_with_devices extension.id, {}, [device.id] }

      it "enqueues delegate job" do
        result = job.perform extension.id
        expect(result).to be_success("Enqueued jobs for extension: #{extension.id}.")
      end

      it "answers failure when extension can't be found" do
        result = job.perform 666
        expect(result).to be_failure("Unable to enqueue jobs for extension: 666.")
      end
    end
  end
end
