# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Croner do
  subject(:croner) { described_class }

  describe ".call" do
    it "answers cron for every minute" do
      expect(croner.call(nil, "minute")).to eq("* * * * *")
    end

    it "answers cron for every specific minute" do
      expect(croner.call(5, "minute")).to eq("*/5 * * * *")
    end

    it "answers cron for every hour" do
      expect(croner.call(nil, "hour")).to eq("0 * * * *")
    end

    it "answers cron for specific hour" do
      expect(croner.call(5, "hour")).to eq("0 */5 * * *")
    end

    it "answers cron for every day" do
      expect(croner.call(nil, "day")).to eq("0 0 * * *")
    end

    it "answers cron for specific day" do
      expect(croner.call(5, "day")).to eq("0 0 */5 * *")
    end

    it "answers cron for every week" do
      expect(croner.call(nil, "week")).to eq("0 0 * * 0")
    end

    it "answers cron for every month" do
      expect(croner.call(nil, "month")).to eq("0 0 1 * *")
    end

    it "answers cron for every specific month" do
      expect(croner.call(5, "month")).to eq("0 0 * */5 *")
    end
  end
end
