# frozen_string_literal: true

require_relative "../../app/providers/sidekiq"

Hanami.app.register_provider :sidekiq, source: Terminus::Providers::Sidekiq
