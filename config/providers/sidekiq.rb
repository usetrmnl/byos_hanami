# frozen_string_literal: true

Hanami.app.register_provider :sidekiq do
  prepare do
    require "sidekiq"
    require "sidekiq-scheduler"
  end

  start do
    # :nocov:
    Sidekiq.configure_server do |configuration|
      configuration.redis = {url: slice[:settings].keyvalue_url}
      configuration.logger = slice[:logger]
    end
    # :nocov:

    Sidekiq.configure_client { it.redis = {url: slice[:settings].keyvalue_url} }

    register :sidekiq, Sidekiq
  end
end
