# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Parts::Device, :db do
  using Refinements::Pathname

  subject(:part) { described_class.new settings:, value: device, rendering: view.new.rendering }

  let(:settings) { Hanami.app[:settings] }
  let(:device) { Factory[:device] }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  include_context "with temporary directory"

  describe "#image_uri" do
    before do
      allow(settings).to receive(:images_root).and_return(temp_dir)

      SPEC_ROOT.join("support/fixtures/test.bmp")
               .copy temp_dir.join("generated/test.bmp").make_ancestors
    end

    it "answers URI" do
      expect(part.image_uri).to eq("https://localhost:2443/assets/images/generated/test.bmp")
    end
  end
end
