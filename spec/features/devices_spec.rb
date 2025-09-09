# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Devices", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }
  let(:model) { Factory[:model] }

  before { model }

  it "creates and views device", :aggregate_failures, :js do
    visit routes.path(:devices)
    click_link "New"
    click_button "Save"

    expect(page).to have_content("must be filled")

    select model.label, from: "device[model_id]"
    fill_in "device[mac_address]", with: "AA:BB:CC:11:22:33"
    click_button "Save"
    click_link "View"

    expect(page).to have_content("AA:BB:CC:11:22:33")
  end

  it "edits and errors when model is not selected", :js do
    visit routes.path(:device_edit, id: device.id)
    select "Select...", from: "device[model_id]"
    click_button "Save"

    expect(page).to have_content("must be filled")
  end

  it "edits and deletes device", :aggregate_failures, :js do
    visit routes.path(:device_edit, id: device.id)
    fill_in "device[label]", with: ""
    click_button "Save"

    expect(page).to have_content("must be filled")

    select model.label, from: "device[model_id]"
    fill_in "device[label]", with: "Device Test"
    click_button "Save"

    expect(page).to have_content("Device Test")
  end

  it "deletes device", :js do
    device
    visit routes.path(:devices)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_content(device.label)
  end
end
