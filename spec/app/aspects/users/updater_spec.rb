# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Users::Updater, :db do
  subject(:updater) { described_class.new }

  include_context "with user statuses"

  describe "#call" do
    let(:user) { Factory[:user] }

    context "with valid attributes" do
      let :attributes do
        {
          id: user.id,
          user: {
            name: "Test User",
            email:,
            status_id: 3
          }
        }
      end

      let(:email) { "#{SecureRandom.hex 10}@test.io" }

      it "updates user when attributes are valid" do
        result = updater.call(**attributes)

        expect(result.success).to have_attributes(
          id: user.id,
          status_id: 3,
          name: "Test User",
          email:
        )
      end

      it "updates password" do
        user
        Factory[:user_password_hash, id: user.id]
        attributes[:user][:password] = "test-12345"
        updater.call(**attributes).value!
        password = BCrypt::Password.new Hanami.app["relations.user_password_hash"]
                                              .by_pk(user.id)
                                              .one[:password_hash]

        expect(password).to eq("test-12345")
      end

      it "doesn't update password when not supplied" do
        user
        updater.call(**attributes).value!

        expect(Hanami.app["relations.user_password_hash"].by_pk(user.id).one).to be(nil)
      end

      it "doesn't update password when blank" do
        user
        attributes[:user][:password] = ""
        updater.call(**attributes).value!

        expect(Hanami.app["relations.user_password_hash"].by_pk(user.id).one).to be(nil)
      end
    end

    it "answers failure when attributes are invalid" do
      result = updater.call
      expect(result.failure.errors.to_h).to eq(id: ["is missing"], user: ["is missing"])
    end
  end
end
