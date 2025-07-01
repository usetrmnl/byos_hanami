# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:playlist) { Factory[:playlist] }

    it "renders htmx response" do
      response = Rack::MockRequest.new(action)
                                  .get "", "HTTP_HX_REQUEST" => "true", params: {id: playlist.id}

      expect(response.body).not_to include("<!DOCTYPE html>")
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
