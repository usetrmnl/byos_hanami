# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Designer", :db do
  it "renders page" do
    visit routes.path(:designer)
    expect(page).to have_content("Welcome to the Terminus designer!")
  end
end
