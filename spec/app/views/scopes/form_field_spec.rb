# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Views::Scopes::FormField do
  subject :scope do
    described_class.new locals: {key: :label, errors:}, rendering: view.new.rendering
  end

  let(:errors) { {label: %w[invalid missing]} }

  let :view do
    Class.new Hanami::View do
      config.paths = [Hanami.app.root.join("app/templates")]
      config.template = "n/a"
    end
  end

  describe "#toggle_error" do
    it "answers default kind without errors" do
      errors.clear
      expect(scope.toggle_error).to eq("form-field")
    end

    it "answers default kind for key with no errors" do
      scope = described_class.new locals: {key: :clean, errors:}, rendering: view.new.rendering
      expect(scope.toggle_error).to eq("form-field")
    end

    it "answers default kind with error class with errors" do
      expect(scope.toggle_error).to eq("form-field error")
    end

    it "answers custom kind with errors" do
      expect(scope.toggle_error("test")).to eq("test error")
    end
  end

  describe "#error_message" do
    it "answers empty string when given no errors" do
      errors.clear
      expect(scope.error_message).to eq("")
    end

    it "answers empty string with missing local" do
      scope = described_class.new rendering: view.new.rendering
      expect(scope.error_message).to eq("")
    end

    it "answers message when given errors" do
      expect(scope.error_message).to eq("invalid and missing")
    end
  end

  describe "#render" do
    it "renders without errors" do
      errors.clear
      content = scope.render { "Test" }

      expect(content).to eq(<<~CONTENT)
        <p class="form-field">
          Test
        </p>
      CONTENT
    end

    it "renders with errors" do
      content = scope.render { "Test" }

      expect(content).to eq(<<~CONTENT)
        <p class="form-field error">
          Test
            <em class="message">invalid and missing</em>
        </p>
      CONTENT
    end
  end
end
