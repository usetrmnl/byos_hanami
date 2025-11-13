# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Croner do
  subject(:croner) { described_class }

  describe ".call" do
    it "answers cron for every minute" do
      expect(croner.call(nil, "minute")).to eq("* * * * *")
    end
  end
end

