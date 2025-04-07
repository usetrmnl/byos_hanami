# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Screens::Toucher do
  using Refinements::Pathname

  subject(:toucher) { described_class }

  include_context "with temporary directory"

  describe "#call" do
    let(:one) { temp_dir.join "one.png" }
    let(:two) { temp_dir.join "two.png" }
    let(:three) { temp_dir.join "three.png" }
    let(:all) { [one, two, three] }

    it "answers second file created as latest file" do
      skip "Doesn't work on CI." if ENV["CI"]

      all.each(&:touch)
      toucher.call temp_dir

      expect(all.sort_by(&:mtime)).to eq([two, three, one])
    end

    it "answers last file created as latest file" do
      skip "Doesn't work on CI." if ENV["CI"]

      all.each(&:touch)
      toucher.call temp_dir
      toucher.call temp_dir

      expect(all.sort_by(&:mtime)).to eq([three, one, two])
    end

    it "answers nil if there is nothing to touch" do
      toucher.call temp_dir
      expect(toucher.call(temp_dir)).to be(nil)
    end
  end
end
