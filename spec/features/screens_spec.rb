# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Screens", :db do
  it "creates, edits, and deletes screen", :aggregate_failures, :js do
    model = Factory[:model]

    visit routes.path(:screens)
    click_link "New"
    select model.label, from: "screen[model_id]"
    fill_in "screen[label]", with: "Test"

    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "screen[name]", with: "test"
    click_button "Save"

    expect(page).to have_content("Test\ntest")

    click_link "Edit"
    fill_in "screen[label]", with: nil
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "screen[label]", with: "Test II"
    fill_in "screen[name]", with: "test_ii"
    click_button "Save"

    expect(page).to have_content("Test II\ntest_ii")

    click_link "Delete"
    expect(page).to have_no_content("Test II\ntest_ii")
  end
end
