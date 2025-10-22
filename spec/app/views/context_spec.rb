# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Context do
  subject(:a_context) { described_class.new }

  describe "#htmx?" do
    it "answers true when htmx request" do
      request = Hanami::Action::Request.new env: {"HTTP_HX_REQUEST" => "true"}, params: {}
      a_context.instance_variable_set :@request, request

      expect(a_context.htmx?).to be(true)
    end

    it "answers false when not a htmx HTTP request" do
      request = Hanami::Action::Request.new env: {}, params: {}
      a_context.instance_variable_set :@request, request

      expect(a_context.htmx?).to be(false)
    end
  end

  describe "#htmx_configuration" do
    it "answers default configuration" do
      expect(a_context.htmx_configuration).to eq(described_class::HTMX_CONFIGURATION.to_json)
    end

    it "answers custom configuration" do
      a_context.content_for :htmx_merge, "defaultSwapStyle" => "innerHTML"

      expect(a_context.htmx_configuration).to eq(
        {"allowScriptTags" => false, "defaultSwapStyle" => "innerHTML"}.to_json
      )
    end
  end
end
