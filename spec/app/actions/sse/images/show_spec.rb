# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::SSE::Images::Show, :db do
  using Refinements::Pathname

  subject(:action) { described_class.new settings: }

  include_context "with temporary directory"

  let(:settings) { Hanami.app[:settings] }

  describe "#call" do
    let(:device) { Factory[:device] }

    before do
      allow(settings).to receive(:images_root).and_return(temp_dir)

      SPEC_ROOT.join("support/fixtures/test.bmp")
               .copy temp_dir.join("generated/test.bmp").make_ancestors
    end

    it "answers 200 OK status with valid parameters" do
      response = action.call id: device.id

      expect(response.body.first).to eq(
        %(data: <img src="https://localhost/assets/images/generated/test.bmp" alt="Latest Image"/>)
      )
    end
  end
end
