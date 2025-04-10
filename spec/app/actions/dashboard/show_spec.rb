# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Dashboard::Show, :db do
  using Refinements::Pathname

  subject(:action) { described_class.new settings: }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }

    it "lists devices" do
      device
      response = action.call Hash.new
      expect(response.body.first).to include("<li>Test</li>")
    end

    it "lists IP addresses" do
      response = action.call Hash.new
      expect(response.body.first).to include(%r(<li.+\d+\.\d+\.\d+.+</li>))
    end

    it "lists firmware" do
      temp_dir.join("0.0.0.bin").touch
      response = action.call Hash.new

      expect(response.body.first).to include(%(<a href="../tmp/rspec/0.0.0.bin">0.0.0</a>))
    end
  end
end
