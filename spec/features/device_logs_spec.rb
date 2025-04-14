# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Device Logs", :db do
  using Refinements::Pathname

  let(:device_log) { Factory[:device_log] }

  it "views device logs", :aggregate_failures do
    device_log
    visit routes.path(:devices_index)
    click_link "Logs"

    expect(page).to have_content("Danger!")

    click_link device_log.id

    expect(page).to have_content("connected")
  end
end
