# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Dashboard", :db do
  using Refinements::Pathname

  let(:device) { Factory[:device] }

  it "lists devices" do
    device
    visit routes.path(:root)

    expect(page).to have_link("Test", href: routes.path(:device_show, id: device.id))
  end

  it "lists IP addresses" do
    visit routes.path(:root)
    expect(page).to have_css("li", text: /\d+\.\d+\.\d+/)
  end

  it "lists firmware" do
    temp_dir.join("0.0.0.bin").touch
    visit routes.path(:root)
    expect(page).to have_link("0.0.0", href: %r(rspec/\d+\.\d+\.\d+))
  end
end
