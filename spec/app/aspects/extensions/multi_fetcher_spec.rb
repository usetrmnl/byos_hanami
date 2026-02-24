# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::MultiFetcher do
  subject(:multi_fetcher) { described_class.new fetcher: }

  let(:fetcher) { instance_double Terminus::Aspects::Extensions::Fetcher }

  describe "#call" do
    let(:extension) { Factory.structs[:extension, uris: ["https://one.io"]] }

    it "answers success with single item" do
      allow(fetcher).to receive(:call).with(extension.uris.first, extension)
                                      .and_return(Success("one"))

      expect(multi_fetcher.call(extension)).to be_success(
        Terminus::Aspects::Extensions::Capsule[content: {"source" => "one"}]
      )
    end

    it "answers failure with single item" do
      allow(fetcher).to receive(:call).with(extension.uris.first, extension)
                                      .and_return(Failure("Danger!"))

      expect(multi_fetcher.call(extension)).to be_failure(
        Terminus::Aspects::Extensions::Capsule[errors: {"https://one.io" => "Danger!"}]
      )
    end

    it "answers failure with mixed successes and failures" do
      extension.uris.append "https://two.io", "https://three.io"
      uris = extension.uris

      allow(fetcher).to receive(:call).with(uris[0], extension).and_return(Success("one"))
      allow(fetcher).to receive(:call).with(uris[1], extension).and_return(Failure("Danger!"))
      allow(fetcher).to receive(:call).with(uris[2], extension).and_return(Success("three"))

      expect(multi_fetcher.call(extension)).to be_failure(
        Terminus::Aspects::Extensions::Capsule[
          content: {"source_1" => "one", "source_3" => "three"},
          errors: {"https://two.io" => "Danger!"}
        ]
      )
    end
  end
end
