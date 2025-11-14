# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Designer::Middleware do
  subject(:middleware) { described_class.new application, pattern: %r(/preview/(?<name>.+)) }

  let(:application) { proc { [200, {}, []] } }

  describe "#call" do
    it "answers event stream when path matches" do
      environment = Rack::MockRequest.env_for "/preview/test", method: :get

      expect(middleware.call(environment)).to match(
        array_including(
          200,
          {
            "Content-Encoding" => "identity",
            "Content-Type" => "text/event-stream",
            "Cache-Control" => "no-cache",
            "X-Accel-Buffering" => "no"
          },
          instance_of(Terminus::Aspects::Screens::Designer::EventStream)
        )
      )
    end

    it "passes name to event stream" do
      event_stream = class_spy Terminus::Aspects::Screens::Designer::EventStream
      middleware = described_class.new(
        application,
        pattern: %r(/preview/(?<name>.+)),
        event_stream:
      )
      environment = Rack::MockRequest.env_for "/preview/test", method: :get
      middleware.call environment

      expect(event_stream).to have_received(:new).with("test")
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
