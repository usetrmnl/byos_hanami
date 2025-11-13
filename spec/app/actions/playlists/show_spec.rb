# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Playlists::Show, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:playlist) { Factory[:playlist] }

    it "renders htmx response" do
      response = action.call Rack::MockRequest.env_for(
        playlist.id.to_s,
        "HTTP_HX_REQUEST" => "true",
        "router.params" => {id: playlist.id}
      )

      expect(response.body.first).to have_htmx_title(/Playlist \d+ Playlist/)
    end

    it "answers unprocessable entity with invalid parameters" do
      response = action.call Hash.new
      expect(response.status).to eq(422)
    end
  end
end
