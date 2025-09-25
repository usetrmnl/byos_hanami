# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Registration", :db do
  it "logout and register", :aggregate_failures do
    visit "/logout"
    check "Logout all Logged In Sessions?"
    click_button "Logout"

    visit "/register"
    fill_in "Name", with: "Jill Test"
    fill_in "Email", with: "jill@test.io"
    fill_in "Confirm Email", with: "bogus"
    click_button "Create"

    expect(page).to have_content "logins do not match"

    fill_in "Confirm Email", with: "jill@test.io"
    fill_in "Password", with: "password-123"
    click_button "Create"

    expect(page).to have_content "Your account has been created"
  end
end
