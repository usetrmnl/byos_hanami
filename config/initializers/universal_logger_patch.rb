# auto_register: false
# frozen_string_literal: true

# Patches Hanami's universal logger to work with Cogger.
module UniversalLoggerPatch
  DEFAULTS = {
    verb: nil,
    status: nil,
    elapsed: nil,
    elapsed_unit: nil,
    ip: nil,
    path: nil,
    length: nil,
    db: nil,
    query: nil
  }.freeze

  def _log_structured method, message, payload
    tags = _current_tags
    block_content = yield if block_given?

    logger.formatter = case tags
                         in [:rack] then tags.delete :rack
                         in [:sql] then tags.delete :sql
                         else Hanami.env == :development ? :emoji : :json
                       end

    unless block_content.is_a? Hash
      message = block_content
      block_content = {}
    end

    combined = {**DEFAULTS, **payload, **block_content}

    logger.public_send method, message, tags:, **combined
  end
end

Hanami::UniversalLogger.prepend UniversalLoggerPatch
