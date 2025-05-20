# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Scopes::PopoverContent do
  subject :scope do
    described_class.new locals: {name: "test", label: "Test"}, rendering: view.new.rendering
  end

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#render" do
    it "renders content" do
      content = scope.render { "<p>A body.</p>" }

      expect(content).to eq(<<~CONTENT)
        <dialog id="popover-test" class="popover-content" popover="auto">
          <button type="button"
                  class="close"
                  popovertarget="popover-test"
                  popovertargetaction="hide">
            <span aria-hidden=true>❌</span>
            <span class="screen_reader">Close</span>
          </button>

          <h3 class="label">Test</h3>

          &lt;p&gt;A body.&lt;/p&gt;
        </dialog>
      CONTENT
    end
  end
end
