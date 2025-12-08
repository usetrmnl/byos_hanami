# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Playlists", :db do
  it "creates, edits, saves, and clones playlist", :aggregate_failures, :js do
    visit routes.path(:playlists)
    click_link "New"
    fill_in "playlist[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "playlist[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test")

    click_link "Edit"
    fill_in "playlist[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "playlist[label]", with: "Test II"
    click_button "Save"

    expect(page).to have_content("Test II")

    visit routes.path(:playlists)
    click_link "Clone"
    fill_in "playlist[name]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "Name", with: "test"
    click_button "Save"

    expect(page).to have_content("must be unique")

    fill_in "playlist[name]", with: "test_clone"
    click_button "Save"

    expect(page).to have_content("Test II Clone")
  end

  it "plays screens", :aggregate_failures, :js do
    playlist = Factory[:playlist]

    visit routes.path(:playlist_screens, playlist_id: playlist.id)

    expect(page).to have_content("No screens found.")

    (1..3).each do |position|
      Factory[
        :playlist_item,
        playlist_id: playlist.id,
        screen_id: Factory[:screen, :with_image].id,
        position:
      ]
    end

    visit routes.path(:playlists)
    click_link "Play"

    expect(page).to have_content(playlist.label)
    expect(page).to have_css(%(#progress[aria-label="Slide 1 of 3"]))
    expect(page).to have_css(%(#progress[value="0"]))
    expect(page).to have_css(%(#progress[max="2"]))

    click_link "Next"

    expect(page).to have_css(%(#progress[aria-label="Slide 2 of 3"]))
    expect(page).to have_css(%(#progress[value="1"]))

    click_link "Next"

    expect(page).to have_css(%(#progress[aria-label="Slide 3 of 3"]))
    expect(page).to have_css(%(#progress[value="2"]))

    click_link "Previous"

    expect(page).to have_css(%(#progress[aria-label="Slide 2 of 3"]))
    expect(page).to have_css(%(#progress[value="1"]))
  end

  it "mirrors playlist to device", :aggregate_failures, :js do
    device = Factory[:device]
    Factory[:playlist, label: "Test"]

    visit routes.path(:playlists)
    click_link "Mirro"
    check device.label
    click_button "Save"

    expect(page).to have_content("Test")

    click_link "Mirror"
    click_link "Cancel"

    expect(page).to have_content("Test")
  end

  it "deletes playlist", :js do
    playlist = Factory[:playlist]

    visit routes.path(:playlists)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_content(playlist.label)
  end
end
