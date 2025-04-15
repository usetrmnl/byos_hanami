# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Editor::Middleware do
  subject(:middleware) { described_class.new application, pattern: %r(/preview/(?<id>\d+)) }

  let(:application) { proc { [200, {}, []] } }

  describe "#call" do
    it "answers event stream when path matches" do
      environment = Rack::MockRequest.env_for "/preview/1", method: :get

      expect(middleware.call(environment)).to match(
        array_including(
          200,
          {
            "Content-Type" => "text/event-stream",
            "Cache-Control" => "no-cache",
            "Connection" => "keep-alive"
          },
          instance_of(Terminus::Aspects::Screens::Editor::EventStream)
        )
      )
    end

    it "passes ID to event stream" do
      event_stream = class_spy Terminus::Aspects::Screens::Editor::EventStream
      middleware = described_class.new(application, pattern: %r(/preview/(?<id>\d+)), event_stream:)
      environment = Rack::MockRequest.env_for "/preview/123", method: :get
      middleware.call environment

      expect(event_stream).to have_received(:new).with("123")
    end

    it "answers original response when path doesn't match" do
      environment = Rack::MockRequest.env_for "/bogus", method: :get
      expect(middleware.call(environment)).to eq([200, {}, []])
    end

    it "answers original response when verb doesn't match" do
      environment = Rack::MockRequest.env_for "/test/1/example", method: :put
      expect(middleware.call(environment)).to eq([200, {}, []])
    end
  end
end
