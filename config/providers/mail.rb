# frozen_string_literal: true

Hanami.app.register_provider :mail do
  prepare { require "mail" }

  start do
    Mail.defaults do
      case Hanami.env
        when :development then delivery_method :smtp, address: "127.0.0.1", port: 1025
        else delivery_method :test
      end
    end

    register :mail, Mail
  end
end
