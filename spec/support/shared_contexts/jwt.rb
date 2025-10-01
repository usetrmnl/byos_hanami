# frozen_string_literal: true

RSpec.shared_context "with JWT" do
  let(:user) { Factory[:user, :verified] }

  let :access_token do
    post "/login",
         {login: user.email, password: "password"}.to_json,
         {"CONTENT_TYPE" => "application/json"}

    JSON[last_response.body, symbolize_names: true].fetch :access_token
  end

  before { Factory[:user_password_hash, id: user.id] }
end
