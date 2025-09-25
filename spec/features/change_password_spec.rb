# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Change Password", :db do
  it "change user password" do
    visit "/me/password"
    fill_in "Password", with: "password"
    fill_in "New Password", with: "password-123"
    click_button "Save"

    expect(page).to have_content "Your password has been changed"
  end
end
