# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Superfluid::Filters::Markdown do
  subject(:filter) { described_class.new }

  describe "#call" do
    it "answers HTML" do
      content = "This is a *test* and [here's a link](https://test.io)."

      expect(filter.call(content)).to eq(
        %(<p>This is a <em>test</em> and <a href="https://test.io">here&#39;s a link</a>.</p>\n)
      )
    end

    it "answers empty string when given no content" do
      expect(filter.call(nil)).to eq("")
    end
  end
end
