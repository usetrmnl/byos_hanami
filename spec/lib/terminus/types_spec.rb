# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Types do
  describe "Browser" do
    subject(:type) { described_class::Browser }

    let(:settings) { {js_errors: true, process_timeout: 1.0, timeout: 2.0} }

    it "answers primitive" do
      expect(type.primitive).to eq(Hash)
    end

    it "answers valid settings" do
      expect(type.call(settings.to_json)).to eq(settings)
    end

    it "answers defaults when empty" do
      expect(type.call("{}")).to eq(js_errors: true, process_timeout: 10, timeout: 10)
    end

    it "ignores unknown settings" do
      expect(type.call({bogus: true}.to_json)).to eq(
        js_errors: true, process_timeout: 10, timeout: 10
      )
    end

    it "fails when unable to parse" do
      expectation = proc { type.call "" }
      expect(&expectation).to raise_error(JSON::ParserError, /unexpected end of input/)
    end

    it "fails with invalid type" do
      expectation = proc { type.call %({"timeout": "danger!"}) }
      expect(&expectation).to raise_error(Dry::Types::SchemaError, /invalid type/)
    end
  end

  describe "Pathname" do
    subject(:type) { described_class::Pathname }

    it "answers primitive" do
      expect(type.primitive).to eq(Pathname)
    end

    it "answers valid pathname" do
      expect(type.call("a/b/c")).to eq(Pathname("a/b/c"))
    end

    it "fails when object can't be coerced" do
      expectation = proc { type.call nil }
      expect(&expectation).to raise_error(Dry::Types::CoercionError, /requires a String/)
    end
  end

  describe "MACAddress" do
    subject(:type) { described_class::MACAddress }

    it "answers primitive" do
      expect(type.primitive).to eq(String)
    end

    it "answers valid string" do
      expect(type.call("A1:B2:C3:D4:E5:F6")).to eq("A1:B2:C3:D4:E5:F6")
    end

    it "fails with too few segments" do
      expectation = proc { type.call "A1:B2:C3" }
      expect(&expectation).to raise_error(Dry::Types::ConstraintError, /violates constraints/)
    end

    it "fails with too many segments" do
      expectation = proc { type.call "A1:B2:C3:D4:E5:F6:G7" }
      expect(&expectation).to raise_error(Dry::Types::ConstraintError, /violates constraints/)
    end

    it "fails when lowercase" do
      expectation = proc { type.call "a1:b2:c3:d4:e5:f6" }
      expect(&expectation).to raise_error(Dry::Types::ConstraintError, /violates constraints/)
    end

    it "fails with no colons" do
      expectation = proc { type.call "A1B2C3D4E5F6" }
      expect(&expectation).to raise_error(Dry::Types::ConstraintError, /violates constraints/)
    end
  end

  describe "Version" do
    subject(:type) { described_class::Version }

    it "answers primitive" do
      expect(type.primitive).to eq(String)
    end

    it "answers valid single digit version" do
      expect(type.call("0.0.0")).to eq("0.0.0")
    end

    it "answers valid multiple digit version" do
      expect(type.call("1.10.100")).to eq("1.10.100")
    end

    it "answers coerces partial version into full version" do
      expectation = proc { type.call "1.2" }
      expect(&expectation).to raise_error(Dry::Types::ConstraintError, /violates constraints/)
    end
  end
end
