# frozen_string_literal: true

require "capybara/cuprite"
require "capybara/rspec"
require "database_cleaner/sequel"
require "dry/monads"
require "rack/test"
require "rom-factory"
require "spec_helper"

ENV["HANAMI_ENV"] = "test"

require "hanami/prepare"

using Refinements::Pathname

Factory = ROM::Factory.configure { |config| config.rom = Hanami.app["db.rom"] }
                      .struct_namespace(Terminus::Structs)

ENV["LD_PRELOAD"] = nil
Capybara.app = Hanami.app
Capybara.server = :puma, {Silent: true, Threads: "0:1"}
Capybara.javascript_driver = :cuprite
Capybara.save_path = Hanami.app.root.join "tmp/capybara"
Capybara.register_driver :cuprite do |app|
  browser_options = {"disable-gpu" => nil, "disable-dev-shm-usage" => nil, "no-sandbox" => nil}
  Capybara::Cuprite::Driver.new app, browser_options:, window_size: [1920, 1080]
end

Pathname.require_tree SPEC_ROOT.join("support/factories")

RSpec.configure do |config|
  config.include Capybara::DSL, Capybara::RSpecMatchers, :web
  config.include Dry::Monads[:result]
  config.include Rack::Test::Methods, type: :request

  config.include_context "with main application", type: :request

  databases = proc do
    Hanami.app.slices.with_nested.prepend(Hanami.app).each.with_object Set.new do |slice, dbs|
      next unless slice.key? "db.rom"

      dbs.merge slice["db.rom"].gateways.values.map(&:connection).to_enum
    end
  end

  config.before :suite do
    databases.call.each do |db|
      DatabaseCleaner[:sequel, db:].clean_with :truncation, except: ["schema_migrations"]
    end
  end

  config.prepend_before :each, :db do |example|
    databases.call.each do |db|
      DatabaseCleaner[:sequel, db:].strategy = example.metadata[:js] ? :truncation : :transaction
      DatabaseCleaner[:sequel, db:].start
    end
  end

  config.append_after :each, :db do
    databases.call.each { |db| DatabaseCleaner[:sequel, db:].clean }
  end
end
