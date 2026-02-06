# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Scopes::PopoverDefaultContent do
  subject :scope do
    described_class.new locals: {name: "test", label: "Test"}, rendering: view.new.rendering
  end

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#dom_id" do
    it "answers ID" do
      expect(scope.dom_id).to eq("popover-test")
    end
  end

  describe "#render" do
    it "renders content" do
      content = scope.render { "<p>A body.</p>" }

      expect(content).to eq(<<~CONTENT)
        <dialog id="popover-test" class="bit-popover-content" popover="auto">
          <button type="button"
                  class="close"
                  popovertarget="popover-test"
                  popovertargetaction="hide"
                  aria-label="Close dialog">
            <span aria-hidden=true>&times;</span>
            <span class="screen_reader">Close</span>
          </button>

          <h1 class="label">Test</h1>

          &lt;p&gt;A body.&lt;/p&gt;
        </dialog>
      CONTENT
    end
  end
end
