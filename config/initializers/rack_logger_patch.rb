# auto_register: false
# frozen_string_literal: true

require "dry/system"

# Patches Hanami's default providers.
module RackLoggerPatch
  def prepare_app_providers
    require "hanami/providers/inflector"

    logger = Class.new Hanami::Provider::Source do
      def start
        slice.start :logger
        register :monitor, Terminus::Aspects::Logging::RackAdapter.with(slice[:logger])
      end
    end

    register_provider :inflector, source: Hanami::Providers::Inflector
    register_provider :rack, source: logger, namespace: true
    register_provider :db_logging, source: Hanami::Providers::DBLogging
  end
end

Hanami::App::ClassMethods.prepend RackLoggerPatch
