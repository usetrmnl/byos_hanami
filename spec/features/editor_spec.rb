# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Editor" do
  it "renders page" do
    visit routes.path(:editor)
    expect(page).to have_content("Welcome to the Terminus editor!")
  end
end
