# frozen_string_literal: true

require "simplecov"

unless ENV["NO_COVERAGE"]
  SimpleCov.start do
    add_filter %r(^/spec/)
    enable_coverage :branch
    minimum_coverage_by_file line: 95, branch: 95
  end
end

Bundler.require :tools

require "dry/monads"
require "http/fake"
require "refinements"

SPEC_ROOT = Pathname(__dir__).realpath.freeze

using Refinements::Pathname

Pathname.require_tree SPEC_ROOT.join("support/shared_contexts")

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
  config.order = :random
  config.pending_failure_output = :no_backtrace
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) { Dry::Monads.load_extensions :rspec }
end
