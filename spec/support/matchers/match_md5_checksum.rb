# frozen_string_literal: true

RSpec::Matchers.define :match_md5_checksum do |prefix: nil, suffix: nil|
  match { |actual| actual.match?(/#{prefix}\h{32}#{suffix}/) }
end
