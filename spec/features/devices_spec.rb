# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Devices", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }

  it "creates and views device", :aggregate_failures do
    visit routes.path(:devices)
    click_link "New"
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "device[mac_address]", with: "AA:BB:CC:11:22:33"
    click_button "Save"
    click_link "View"

    expect(page).to have_content("AA:BB:CC:11:22:33")
  end

  it "edits and deletes device", :aggregate_failures, :js do
    visit routes.path(:device_edit, id: device.id)
    fill_in "device[label]", with: ""
    click_button "Save"

    expect(page).to have_content("must be filled")

    fill_in "device[label]", with: "Device Test"
    click_button "Save"

    expect(page).to have_content("Device Test")

    visit routes.path(:devices)
    accept_prompt { click_link "Delete" }

    expect(page).to have_no_content("Device Test")
  end
end
