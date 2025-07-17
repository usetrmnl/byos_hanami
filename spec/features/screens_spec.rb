# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Screens", :db do
  it "creates and edits screen", :aggregate_failures, :js do
    model = Factory[:model]

    visit routes.path(:screens)
    click_link "New"
    select model.label, from: "screen[model_id]"
    fill_in "screen[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "screen[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test")

    click_link "Edit"
    fill_in "screen[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "screen[label]", with: "Test II"
    click_button "Save"

    expect(page).to have_content("Test II")
  end

  it "deletes screen", :js do
    screen = Factory[:screen]

    visit routes.path(:screens)
    accept_prompt { click_link "Delete" }

    expect(page).to have_no_content(screen.label)
  end
end
