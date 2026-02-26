# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Dashboard", :db do
  let(:device) { Factory[:device] }

  it "lists devices" do
    device
    visit routes.path(:root)

    expect(page).to have_link("Test", href: routes.path(:device, id: device.id))
  end

  it "lists IP addresses" do
    visit routes.path(:root)
    expect(page).to have_css("li", text: /\d+\.\d+\.\d+/)
  end

  it "lists firmware" do
    firmware = Factory[:firmware]
    visit routes.path(:root)

    expect(page).to have_link(
      "0.0.0",
      href: Hanami.app[:routes].path(:firmware_show, id: firmware.id)
    )
  end
end
