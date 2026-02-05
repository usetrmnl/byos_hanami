# frozen_string_literal: true

RSpec::Matchers.define :have_htmx_title do |text|
  match { |actual| actual.start_with? %r(\n*<title>#{text} | Terminus</title>) }
end
