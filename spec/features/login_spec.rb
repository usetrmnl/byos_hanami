# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Login", :db do
  it "logout and login", :aggregate_failures do
    visit "/logout"
    check "Logout all Logged In Sessions?"
    click_button "Logout"

    expect(page).to have_content "Please log in to continue."

    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content "You have been logged in."
  end
end
