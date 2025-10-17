# frozen_string_literal: true

Hanami.app.register_provider :logger do
  prepare { require "cogger" }

  start do
    Cogger.add_filters :api_key,
                       :csrf,
                       :HTTP_ACCESS_TOKEN,
                       :HTTP_ID,
                       :mac_address,
                       :password,
                       :password_confirmation

    environment = Hanami.env
    id = :terminus
    io = "log/#{environment}.log"

    # :nocov:
    logger = case environment
               when :development then Cogger.new(id:).add_stream(io:, formatter: :json)
               when :test
                 Cogger.new(id:, io: StringIO.new, formatter: :detail, level: :debug)
                       .add_stream io:, formatter: :json
               else Cogger.new id:, formatter: :json
             end
    # :nocov:

    register :logger, logger
  end
end
