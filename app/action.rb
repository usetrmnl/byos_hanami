# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module Terminus
  # The application base action.
  class Action < Hanami::Action
    before :authorize

    protected

    # :reek:FeatureEnvy
    def authorize request, response
      rodauth = request.env["rodauth"]

      handle_rodauth_redirect(rodauth, response) { rodauth.require_account }

      response[:current_account_id] = rodauth.account_id
    end

    private

    # :reek:TooManyStatements
    def handle_rodauth_redirect rodauth, response
      halted = catch(:halt) { yield }

      return unless halted

      code, headers, body = *halted
      rodauth.flash.next.each { |key, value| response.flash[key] = value }

      # rubocop:todo Style/MethodCallWithArgsParentheses
      # rubocop:todo Style/MissingElse
      if (redirect_to = headers["Location"])
        response.redirect(redirect_to, code)
      end
      # rubocop:enable Style/MethodCallWithArgsParentheses
      # rubocop:enable Style/MissingElse

      throw :halt, [code, body]
    end
  end
end
