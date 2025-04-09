# frozen_string_literal: true

RSpec.shared_context "with main application" do
  include_context "with temporary directory"

  let(:app) { Hanami.app }
  let(:settings) { app[:settings] }

  before do
    allow(settings).to receive_messages(
      api_uri: "https://localhost",
      firmware_root: temp_dir,
      screens_root: temp_dir
    )
  end
end
