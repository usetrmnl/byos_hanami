# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Extensions", :db do
  it "creates and edits extension", :aggregate_failures, :js do
    visit routes.path(:extensions)
    click_link "New"
    fill_in "extension[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "extension[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test")
    expect(page).to have_content("poll")

    click_link "Edit"

    expect(page).to have_field(with: "Test")
    expect(page).to have_field(with: "test")

    fill_in "extension[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "extension[label]", with: "Test"
    click_button "Save"

    expect(page).to have_content("Changes saved.")
    expect(page).to have_field(with: "Test")
  end

  it "deletes extension", :js do
    extension = Factory[:extension]

    visit routes.path(:extensions)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_content(extension.label)
  end
end
