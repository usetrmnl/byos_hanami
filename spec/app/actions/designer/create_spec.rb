# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Designer::Create do
  subject(:action) { described_class.new }

  include_context "with main application"

  describe "#call" do
    let(:device) { Factory[:device] }
    let(:parameters) { {template: {id: 123, content: "<p>Test</p>"}} }

    it "answers original content" do
      response = Rack::MockRequest.new(action).post "",
                                                    "HTTP_HX_REQUEST" => true,
                                                    params: parameters
      expect(response.body).to eq("<p>Test</p>")
    end

    it "creates preview image" do
      Rack::MockRequest.new(action).post "", "HTTP_HX_REQUEST" => true, params: parameters
      expect(temp_dir.join("123.bmp").exist?).to be(true)
    end

    it "answers created status" do
      response = Rack::MockRequest.new(action).post "",
                                                    "HTTP_HX_REQUEST" => true,
                                                    params: parameters

      expect(response.status).to eq(201)
    end

    it "renders show view when form is submitted" do
      response = Rack::MockRequest.new(action).post "", params: parameters
      expect(response.body).to include("Welcome to the Terminus designer!")
    end

    it "answers unprocessable content with invalid parameters" do
      parameters[:template].delete :id
      response = Rack::MockRequest.new(action).post "", params: parameters

      expect(response.status).to eq(422)
    end
  end
end
