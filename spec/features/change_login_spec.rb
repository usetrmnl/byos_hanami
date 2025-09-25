# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Change Login", :db do
  it "change user login", :aggregate_failures do
    visit "/me/login"
    fill_in "Email", with: "alternative@test.io"
    fill_in "Confirm Email", with: "bogus"
    fill_in "Password", with: "password"
    click_button "Save"

    expect(page).to have_content "logins do not match"

    fill_in "Confirm Email", with: "alternative@test.io"
    fill_in "Password", with: "password"
    click_button "Save"

    expect(page).to have_content "Your login has been changed"
  end
end
