# frozen_string_literal: true

Hanami.app.register_provider :sidekiq do
  prepare { require "sidekiq" }

  start do
    Sidekiq.configure_server do |configuration|
      configuration.redis = {url: slice[:settings].redis_url}
      configuration.logger = slice[:logger]
    end

    Sidekiq.configure_client { it.redis = {url: slice[:settings].redis_url} }
  end
end
