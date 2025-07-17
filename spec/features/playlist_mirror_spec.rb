# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Playlist Mirror", :db do
  let(:playlist) { Factory[:playlist, label: "Test"] }
  let(:device) { Factory[:device] }

  it "cancels, edits, and updates playlist mirror", :aggregate_failures, :js do
    device
    visit routes.path(:playlist_mirror_edit, id: playlist.id)
    click_link "Cancel"

    expect(page).to have_content("Test")

    click_link "Mirror"
    check device.label
    click_button "Save"

    expect(page).to have_content("Test")
  end
end
