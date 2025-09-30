# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Users::Creator, :db do
  subject(:creator) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    context "with valid attributes" do
      let(:attributes) { {user: {name: "Test User", email:, password: "test-1234567890"}} }
      let(:email) { "#{SecureRandom.hex 10}@test.io" }

      it "creates user when attributes are valid" do
        result = creator.call(**attributes.merge!(email:))
        expect(result.success).to have_attributes(status_id: 1, name: "Test User", email:)
      end

      it "creates password" do
        user = creator.call(**attributes).value!
        password = BCrypt::Password.new Hanami.app["relations.user_password_hash"]
                                              .by_pk(user.id)
                                              .one[:password_hash]

        expect(password).to eq("test-1234567890")
      end

      it "creates default account" do
        creator.call(**attributes).value!

        expect(Hanami.app["repositories.account"].find_by(name: "default")).to have_attributes(
          name: "default",
          label: "Default"
        )
      end

      it "creates membership" do
        user = creator.call(**attributes).value!
        account = Hanami.app["repositories.account"].find_by name: "default"

        expect(Hanami.app["relations.membership"].first).to match(
          id: kind_of(Integer),
          user_id: user.id,
          account_id: account.id,
          created_at: kind_of(Time),
          updated_at: kind_of(Time)
        )
      end
    end

    it "answers failure when attributes are invalid" do
      result = creator.call
      expect(result.failure.errors.to_h).to eq(user: ["is missing"])
    end
  end
end
