# frozen_string_literal: true

RSpec.shared_context "with library dependencies" do
  let(:logger) { Cogger.new id: :terminus, io: StringIO.new, level: :debug }

  before { Terminus::LibContainer.stub! http:, logger: }

  after { Terminus::LibContainer.restore }
end
