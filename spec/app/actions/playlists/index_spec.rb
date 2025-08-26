# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Index, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let :playlist do
      playlist = Factory[:playlist, label: "Test", name: "test"]
      screen = Factory[:screen, :with_image]
      item = Factory[:playlist_item, playlist_id: playlist.id, screen_id: screen.id]

      repository = Hanami.app["repositories.playlist"]
      repository.update playlist.id, current_item_id: item.id
      repository.find playlist.id
    end

    it "renders standard response with search results" do
      response = Rack::MockRequest.new(action).get "", params: {query: playlist.label}
      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders standard response with no results" do
      response = Rack::MockRequest.new(action).get "", params: {query: "bogus"}
      expect(response.body).to include("No playlists found.")
    end

    it "renders htmx response with search results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: playlist.label}

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end

    it "renders htmx response with no results" do
      response = Rack::MockRequest.new(action).get "",
                                                   "HTTP_HX_TRIGGER" => "search",
                                                   params: {query: "bogus"}

      expect(response.body).to include("No playlists found.")
    end

    it "renders all playlists with no query" do
      playlist
      response = Rack::MockRequest.new(action).get "", "HTTP_HX_TRIGGER" => "search"

      expect(response.body).to include(%(<h2 class="label">Test</h2>))
    end
  end
end
