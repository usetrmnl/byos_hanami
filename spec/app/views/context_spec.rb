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
end
