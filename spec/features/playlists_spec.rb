# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Playlists", :db do
  it "creates, edits, and deletes playlist", :aggregate_failures, :js do
    visit routes.path(:playlists)
    click_link "New"
    fill_in "playlist[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "playlist[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test\ntest")

    click_link "Edit"
    fill_in "playlist[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "playlist[label]", with: "Test II"
    fill_in "playlist[name]", with: "test_ii"
    click_button "Save"

    expect(page).to have_content("Test II\ntest_ii")

    click_link "Delete"
    expect(page).to have_no_content("Test II\ntest_ii")
  end
end
