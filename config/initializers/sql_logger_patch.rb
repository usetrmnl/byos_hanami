# frozen_string_literal: true

require "dry-monitor"
require "dry/monitor/sql/logger"

Dry::Monitor::SQL::Logger.class_eval do
  # :reek:UtilityFunction
  def log_query time:, name:, query:
    Hanami.app[:logger].info { {message: query, tags: [{db: name, duration: time}]} }
  end
end
