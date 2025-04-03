# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Screens::Randomizer do
  subject(:randomizer) { described_class }

  it "answers UUID by default" do
    expect(randomizer.call).to match(/\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/)
  end
end
