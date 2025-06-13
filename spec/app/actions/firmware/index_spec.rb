# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Firmware::Index, :db do
  subject(:action) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let :firmware do
      path = temp_dir.join "test.bin"
      path.binwrite [123].pack("N")
      repository.update Factory[:firmware].id, attachment: Shrine.upload(path.open, :store).data
    end

    let(:repository) { Terminus::Repositories::Firmware.new }
    let(:proof) { %r(<td>.+0\.0\.0.+</td>) }

    before { firmware }

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "0.0"}
      expect(response.body).to match(proof)
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "bogus"}
      expect(response.body).to include("No firmware found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "0.0"}

      expect(response.body).to match(proof)
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "bogus"}

      expect(response.body).to include("No firmware found.")
    end

    it "renders all devices with empty query" do
      response = Rack::MockRequest.new(action).get "", params: {query: ""}
      expect(response.body).to match(proof)
    end

    it "renders all devices with no query" do
      response = Rack::MockRequest.new(action).get ""
      expect(response.body).to match(proof)
    end
  end
end
