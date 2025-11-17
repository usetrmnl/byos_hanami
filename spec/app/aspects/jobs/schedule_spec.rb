# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Jobs::Schedule do
  subject(:schedule) { described_class.new }

  let(:extension) { Factory.structs[:extension, id: 1, label: "Test", name: "test"] }
  let(:sidekiq) { Hanami.app[:sidekiq] }

  describe "#upsert" do
    it "creates schedule" do
      schedule.upsert(*extension.to_schedule)

      expect(sidekiq.get_all_schedules).to eq(
        "extension-test" => {
          "cron" => "",
          "class" => "Terminus::Jobs::Batches::Extension",
          "args" => [1],
          "description" => "The Test extension update schedule."
        }
      )
    end

    it "updates schedule" do
      schedule.upsert(*extension.to_schedule)

      schedule.upsert(
        "extension-test",
        {
          cron: "* * * * *",
          class: "Terminus::Jobs::Batches::Extension",
          args: [1],
          description: "The Test extension update schedule."
        }
      )

      expect(sidekiq.get_all_schedules).to eq(
        "extension-test" => {
          "cron" => "* * * * *",
          "class" => "Terminus::Jobs::Batches::Extension",
          "args" => [1],
          "description" => "The Test extension update schedule."
        }
      )
    end

    it "updates schedule name and removes old schedule" do
      schedule.upsert(*extension.to_schedule)

      schedule.upsert(
        "extension-two",
        {
          cron: "",
          class: "Terminus::Jobs::Batches::Extension",
          args: [1],
          description: "The Test extension update schedule."
        },
        old_name: "extension-test"
      )

      expect(sidekiq.get_all_schedules).to eq(
        "extension-two" => {
          "cron" => "",
          "class" => "Terminus::Jobs::Batches::Extension",
          "args" => [1],
          "description" => "The Test extension update schedule."
        }
      )
    end
  end

  describe "#delete" do
    it "removes schedule" do
      schedule.upsert(*extension.to_schedule)
      schedule.delete extension.screen_name

      expect(sidekiq.get_all_schedules).to eq({})
    end
  end
end
