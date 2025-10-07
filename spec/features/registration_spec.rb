# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Registration", :db do
  let(:database) { Hanami.app["db.gateway"].connection }

  before do
    visit "/logout"
    check "Logout all Logged In Sessions?"
    click_button "Logout"

    database[:user_active_session_key].delete
    database[:user_authentication_audit_log].delete
    database[:user_jwt_refresh_key].delete
    database[:user_password_hash].delete
    database[:user].delete
  end

  it "register first user", :aggregate_failures do
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

  it "registers multiple users for the default account", :aggregate_failures do
    visit "/register"
    fill_in "Name", with: "Jill Test"
    fill_in "Email", with: "jill@test.io"
    fill_in "Confirm Email", with: "jill@test.io"
    fill_in "Password", with: "password-123"
    click_button "Create"

    expect(page).to have_content "Your account has been created"
    expect(database[:user].where(email: "jill@test.io").first).to include(status_id: 2)

    visit "/logout"
    check "Logout all Logged In Sessions?"
    click_button "Logout"

    visit "/register"
    fill_in "Name", with: "Jim Test"
    fill_in "Email", with: "jim@test.io"
    fill_in "Confirm Email", with: "jim@test.io"
    fill_in "Password", with: "password-123"
    click_button "Create"

    expect(page).to have_content "Your account requires verification before proceeding. " \
                                 "Please contact administration for access"
  end
end
