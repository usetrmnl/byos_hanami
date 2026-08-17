# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Sidekiq Web", :db do
  it "views UI when logged in" do
    visit "/sidekiq"
    expect(page).to have_text "Sidekiq"
  end

  it "is redirected to login when logged out and trying to view the UI" do
    visit "/logout"
    click_button "Logout"
    visit "/sidekiq"

    expect(page).to have_text "Please log in to continue."
  end
end
