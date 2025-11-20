# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::PasswordEncryptor do
  subject(:encryptor) { described_class.new password: }

  let(:password) { class_spy BCrypt::Password }

  describe "#call" do
    it "uses minimum cost when in test environment" do
      encryptor.call "test", environment: :test
      expect(password).to have_received(:create).with("test", cost: BCrypt::Engine::MIN_COST)
    end

    it "uses maximum cost when in nont-test environment" do
      encryptor.call "test", environment: :development
      expect(password).to have_received(:create).with("test", cost: BCrypt::Engine::DEFAULT_COST)
    end
  end
end
