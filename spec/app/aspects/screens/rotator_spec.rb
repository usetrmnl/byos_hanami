# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Rotator, :db do
  subject(:rotator) { described_class.new }

  describe "#call" do
    let :device do
      provisioner.call(model_id: Factory[:model].id, mac_address: "A1:B2:C3:D4:E5:F6").value!
    end

    let(:provisioner) { Terminus::Aspects::Devices::Provisioner.new }
    let(:playlist_repository) { Terminus::Repositories::Playlist.new }
    let(:item_repository) { Terminus::Repositories::PlaylistItem.new }

    it "answers current screen when playlist has single item" do
      expect(rotator.call(device).success).to have_attributes(label: /Welcome/)
    end

    it "answers next screen when current screen isn't last" do
      Factory[
        :playlist_item,
        playlist_id: device.playlist_id,
        screen_id: Factory[:screen, label: "Test"].id,
        position: 2
      ]

      expect(rotator.call(device).success).to have_attributes(label: "Test")
    end

    it "answers first screen when current screen is last screen" do
      screen = Factory[:screen, label: "Test"]

      item = Factory[
        :playlist_item,
        playlist_id: device.playlist_id,
        screen_id: screen.id,
        position: 2
      ]

      playlist_repository.update device.playlist_id, current_item_id: item.id

      expect(rotator.call(device).success).to have_attributes(label: /Welcome/)
    end
  end
end
