# frozen_string_literal: true

RSpec.shared_context "with login" do
  let(:user) { Factory[:user, :verified] }

  before do
    Factory[:user_password_hash, id: user.id]

    visit "/login"
    fill_in "login", with: user.email
    click_button "Login"

    fill_in "Password", with: "password"
    click_button "Login"
  end
end
