# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Screen Creation Problem Details" do
  it "renders page" do
    visit routes.path(:problem_screen_creation)
    expect(page).to have_content("Screen Creation Problem Details")
  end
end
