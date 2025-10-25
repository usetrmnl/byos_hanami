# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Logging::RackAdapter do
  subject(:adapter) { described_class }

  include_context "with application dependencies"

  let(:application) { proc { [200, {"Content-Type" => "text/plain"}, "test"] } }

  describe ".with" do
    it "answers itself" do
      expect(adapter.with(nil)).to eq(adapter)
    end
  end

  describe ".new" do
    it "answers Cogger middleware" do
      expect(adapter.with(logger).new(application)).to be_a(Cogger::Rack::Logger)
    end
  end

  describe ".call" do
    let(:middleware) { adapter.with(logger).new application }

    it "answers application" do
      expect(middleware.call({})).to eq([200, {"Content-Type" => "text/plain"}, "test"])
    end

    it "logs request" do
      middleware.call({})
      expect(logger.reread).to match(/level.+INFO.+status.+200/)
    end
  end
end
