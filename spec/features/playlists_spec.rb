# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Playlists", :db do
  it "creates and edits playlist", :aggregate_failures, :js do
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
  end

  it "deletes playlist", :js do
    playlist = Factory[:playlist]

    visit routes.path(:playlists)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_content(playlist.label)
  end
end
