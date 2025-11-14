# frozen_string_literal: true

require "dry-monitor"
require "dry/monitor/sql/logger"

# Patches Hanami's default SQL logger.
module SQLLoggerPatch
  def log_query time:, name:, query:
    Hanami.app[:logger].info { {message: query, tags: [{db: name, duration: time}]} }
  end
end

Dry::Monitor::SQL::Logger.prepend SQLLoggerPatch
