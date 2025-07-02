# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Mirror::Update, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:playlist) { Factory[:playlist] }
    let(:device) { Factory[:device] }

    it "answers not found for unknown playlist" do
      response = action.call id: 666
      expect(response.status).to eq(404)
    end

    it "renders non-htmx response" do
      response = action.call id: playlist.id
      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = Rack::MockRequest.new(action)
                                  .get "", "HTTP_HX_REQUEST" => "true", params: {id: playlist.id}

      expect(response.body).not_to include("<!DOCTYPE html>")
    end
  end
end
