# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Screens::Encoder, :db do
  subject(:encrypter) { described_class.new }

  describe "#call" do
    let(:path) { SPEC_ROOT.join "support/fixtures/test.png" }
    let(:screen) { Factory[:screen, updated_at: "2025-08-01T10:10:10+0000"] }

    before { path.open { |io| screen.upload io } }

    it "answers default image URI" do
      expect(encrypter.call(screen)).to be_success(
        filename: "test-1754043010.png",
        image_url: "memory://#{screen.image_id}"
      )
    end

    it "answers encrypted data URI" do
      result = encrypter.call screen, encryption: :base_64

      expect(result.success).to match(
        filename: "test-1754043010.png",
        image_url: %r(data:image/png;base64,.+)
      )
    end
  end
end
