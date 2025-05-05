# frozen_string_literal: true

RSpec.shared_context "with library dependencies" do
  let(:http) { class_spy HTTP }
  let(:logger) { Cogger.new id: :terminus, io: StringIO.new, level: :debug, formatter: :detail }

  before { Terminus::LibContainer.stub! http:, logger: }

  after { Terminus::LibContainer.restore }
end
