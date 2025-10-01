# frozen_string_literal: true

RSpec.shared_context "with user statuses" do
  let(:user_status_relation) { Hanami.app["relations.user_status"] }

  before do
    %w[Unverified Verified Closed].each.with_index 1 do |name, id|
      user_status_relation.upsert id:, name:
    end
  end
end
