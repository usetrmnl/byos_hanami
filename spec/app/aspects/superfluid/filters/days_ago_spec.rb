# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::DaysAgo do
  subject(:filter) { described_class }

  describe "#call" do
    let(:timezone) { class_double TZInfo::Timezone }
    let(:data_time_zone) { instance_double TZInfo::DataTimezone, now: time_with_offset }
    let(:time_with_offset) { instance_double TZInfo::TimeWithOffset, to_date: date }
    let(:date) { Date.parse "2026-09-01" }

    it "answers days for default timezone" do
      allow(timezone).to receive(:get).with("Etc/UTC").and_return(data_time_zone)
      expect(filter.call(3, timezone:)).to eq(date - 3)
    end

    it "answers days for custom timezone" do
      allow(timezone).to receive(:get).with("Europe/London").and_return(data_time_zone)
      expect(filter.call(3, "Europe/London", timezone:)).to eq(date - 3)
    end
  end
end
