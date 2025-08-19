# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Models", :db do
  it "creates and edits model", :aggregate_failures, :js do
    visit routes.path(:models)
    click_link "New"
    fill_in "model[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "model[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test")

    click_link "Edit"
    fill_in "model[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "model[label]", with: "Test II"
    click_button "Save"

    expect(page).to have_content("Test II")
  end

  it "deletes model", :js do
    model = Factory[:model]

    visit routes.path(:models)
    accept_prompt { click_link "Delete" }

    expect(page).to have_no_content(model.label)
  end
end
