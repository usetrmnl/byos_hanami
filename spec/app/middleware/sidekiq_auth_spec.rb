# frozen_string_literal: true

require "hanami_helper"
require "rodauth"

RSpec.describe Terminus::Middleware::SidekiqAuth do
  subject(:middleware) { described_class.new sidekiq_web }

  let(:sidekiq_web) { proc { [200, {"Content-Type" => "text/plain"}, ["Sidekiq UI"]] } }

  # rubocop:todo RSpec/VerifiedDoubles
  describe "#call" do
    it "accesses the Sidekiq Web when authenticated" do
      rodauth = double("Rodauth").tap do |instance|
        allow(instance).to receive(:require_account).and_return(true)
      end

      _status, _headers, body = middleware.call({"rodauth" => rodauth})

      expect(body).to contain_exactly("Sidekiq UI")
    end

    it "redirects when not authenticated" do
      rodauth = double("Rodauth").tap do |instance|
        allow(instance).to receive(:require_account) do
          throw :halt,
                [
                  302,
                  {"Location" => "/login", "Content-Type" => "text/html"},
                  ["Redirecting to login..."]
                ]
        end
      end

      _status, _headers, body = middleware.call({"rodauth" => rodauth})

      expect(body).to contain_exactly("Redirecting to login...")
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles
end
