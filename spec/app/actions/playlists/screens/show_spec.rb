# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Screens::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:playlist) { Factory[:playlist] }
    let(:screen) { Factory[:screen, :with_image] }

    before { Factory[:playlist_item, playlist_id: playlist.id, screen_id: screen.id] }

    it "renders default response" do
      response = action.call Rack::MockRequest.env_for(
        playlist.id.to_s,
        "router.params" => {playlist_id: playlist.id, id: screen.id}
      )

      expect(response.body.first).to include("<!DOCTYPE html>")
    end

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        playlist.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {playlist_id: playlist.id, id: screen.id}
      )

      expect(response.body.first).to have_htmx_title(/Playlist \d+ Screens/)
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
