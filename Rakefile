# frozen_string_literal: true

require "bundler/setup"
require "git/lint/rake/register"
require "hanami/rake_tasks"
require "reek/rake/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"

Git::Lint::Rake::Register.call
Reek::Rake::Task.new
RSpec::Core::RakeTask.new { |task| task.verbose = false }
RuboCop::RakeTask.new

Rake.add_rakelib "lib/tasks"

desc "Run code quality checks"
task quality: %i[git_lint reek rubocop]

task default: %i[quality spec]
