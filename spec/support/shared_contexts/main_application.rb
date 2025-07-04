# frozen_string_literal: true

RSpec.shared_context "with main application" do
  include_context "with temporary directory"

  let(:app) { Hanami.app }
  let(:settings) { app[:settings] }
  let(:routes) { app[:routes] }
  let(:json_payload) { JSON last_response.body, symbolize_names: true }

  before do
    allow(settings).to receive_messages(
      api_uri: "https://localhost",
      previews_root: temp_dir,
      screens_root: temp_dir
    )
  end
end
