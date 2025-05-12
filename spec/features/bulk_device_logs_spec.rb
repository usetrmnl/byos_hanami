# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Bulk Device Logs", :db do
  let(:log) { Factory[:device_log] }

  it "deletes all device logs", :js do
    log
    visit routes.path(:device_logs, device_id: log.device_id)
    accept_prompt { click_link "Delete All" }

    expect(page).to have_content("No logs found.")
  end
end
