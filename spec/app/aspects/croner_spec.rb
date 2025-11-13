# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Croner do
  subject(:croner) { described_class }

  describe ".call" do
    it "answers cron for every minute" do
      expect(croner.call("1 minute")).to eq("* * * * *")
    end
  end
end

# TODO: Remove when finished.
__END__

Fugit::Nat.parse("every 1 minute").original                              # "* * * * *"
Fugit::Nat.parse("every 1 hour").original                                # "0 * * * *"
Fugit::Nat.parse("every 1 day").original                                 # "0 0 * * *"
Fugit::Nat.parse("every 1 monday, wednesday, and friday").original       # "0 0 * * 1,3,5"
Fugit::Nat.parse("every second monday, wednesday, and friday").original  # nil
Fugit::Nat.parse("every 1 week").original                                # "0 0 * * 0"
Fugit::Nat.parse("every 1 month").original                               # "0 0 1 * *"
Fugit::Nat.parse("every 5th and 15th of the month").original             # Invalid
Fugit::Nat.parse("every last day of the month").original                 # nil
Fugit::Nat.parse("every 1 year").original                                # "0 0 1 1 *"
