# auto_register: false
# frozen_string_literal: true

require "hanami/view"

module Terminus
  module Views
    # The application custom view context.
    # :reek:InstanceVariableAssumption
    class Context < Hanami::View::Context
      include Deps[:htmx, user_repository: "repositories.user"]

      def htmx? = htmx.request? request.env, :request, "true"

      def signed_in? = rodauth.logged_in?

      def current_user
        return @current_user if instance_variable_defined? :@current_user

        @current_user = begin
                          rodauth.account_from_session
                          account_id = rodauth.account_id

                          user_repository.get_for_account account_id if account_id
                        end
      end

      def rodauth = request.env["rodauth"]
    end
  end
end
