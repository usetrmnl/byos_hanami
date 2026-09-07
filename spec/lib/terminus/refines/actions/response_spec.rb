# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Refines::Actions::Response do
  using described_class

  subject :response do
    config = Class.new(Hanami::Action).config.tap do |action|
      action.formats.register :problem_details, RFC::API::Problem::MEDIA_TYPE_JSON
    end

    Hanami::Action::Response.new request:, config:
  end

  let :request do
    Rack::MockRequest.env_for("/").then { |env| Hanami::Action::Request.new env:, params: {} }
  end

  describe "#with_details" do
    let(:problem) { RFC::API::Problem[status: :not_found] }

    it "answers response with required body and status" do
      expect(response.with_details(problem)).to have_attributes(
        body: [{type: "about:blank", title: "Not Found", status: 404}.to_json],
        format: :problem_details,
        status: 404
      )
    end

    it "answers itself" do
      expect(response.with_details(problem)).to be_a(Hanami::Action::Response)
    end
  end

  describe "#with" do
    it "answers response with required body and status" do
      expect(response.with(body: "A test.")).to have_attributes(
        body: ["A test."],
        format: nil,
        status: 200
      )
    end

    it "answers response with body, format, and status" do
      expect(response.with(body: "Danger!", format: :json, status: 400)).to have_attributes(
        body: ["Danger!"],
        format: :json,
        status: 400
      )
    end

    it "answers itself" do
      expect(response.with(body: "Danger!", status: 400)).to be_a(Hanami::Action::Response)
    end
  end
end
