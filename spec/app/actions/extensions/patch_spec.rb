# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Actions::Extensions::Patch, :db do
  subject(:action) { described_class.new }

  describe "#call" do
    let(:extension) { Factory[:extension] }
    let(:params) { {id: extension.id, extension: {label: "Test", name: "test"}} }
    let(:repository) { Hanami.app["repositories.extension"] }

    it "patches existing record" do
      Rack::MockRequest.new(action).patch("", params:)
      record = repository.find extension.id

      expect(record).to have_attributes(label: "Test", name: "test")
    end

    it "answers unprocessable entity for unknown ID" do
      response = action.call id: 666
      expect(response.status).to eq(422)
    end
  end
end
