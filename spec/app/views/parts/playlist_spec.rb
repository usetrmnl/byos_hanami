# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Playlist, :db do
  subject :part do
    playlist = Factory[:playlist]
    screen = Factory[:screen, :with_image]
    item = Factory[:playlist_item, playlist_id: playlist.id, screen_id: screen.id]

    repository = Hanami.app["repositories.playlist"]
    repository.update playlist.id, current_item_id: item.id

    described_class.new value: repository.find(playlist.id), rendering: rendering
  end

  let(:rendering) { view.new.rendering }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  before { allow(rendering).to receive(:context).and_return Terminus::Views::Context.new }

  describe "#current_screen_pill" do
    it "answers pill when current item, screen, and image exist" do
      expect(part.current_screen_pill(part.current_item)).to eq(
        %(<div class="bit-pill bit-pill-active">Current Screen</div>)
      )
    end

    it "answers pill with custom label" do
      expect(part.current_screen_pill(part.current_item, "Test")).to eq(
        %(<div class="bit-pill bit-pill-active">Test</div>)
      )
    end

    it "answers nil when current item is missing" do
      part = described_class.new value: Factory[:playlist], rendering: view.new.rendering
      item = Factory[:playlist_item]

      expect(part.current_screen_pill(item)).to be(nil)
    end
  end

  describe "#current_screen_uri" do
    it "answers URI when current item, screen, and image exist" do
      expect(part.current_screen_uri).to eq("memory://abc123.png")
    end

    it "answers fallback when current item is missing" do
      part = described_class.new value: Factory[:playlist], rendering: view.new.rendering
      expect(part.current_screen_uri).to match(%r(/assets/blank.*\.svg))
    end
  end
end
