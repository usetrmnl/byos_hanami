# auto_register: false
# frozen_string_literal: true

require "refinements/string"
require "roda"
require "rodauth"

require_relative "feature"

module Authentication
  # Specialized Roda middleware for authentication.
  class Middleware < Roda
    using Refinements::String

    plugin :middleware

    plugin :rodauth, json: true do
      enable :active_sessions,
             :audit_logging,
             :change_login,
             :change_password,
             :create_account,
             :disallow_common_passwords,
             :hanami,
             :jwt_refresh,
             :login,
             :logout,
             :remember,
             :recovery_codes

      db Authentication::Slice["db.gateway"].connection

      # Feature (automatic): base
      accounts_table :user
      after_login { remember_login }
      already_logged_in { redirect "/" }
      flash_error_key :alert
      hmac_secret Hanami.app[:settings].app_secret
      login_label "Email"
      password_hash_table :user_password_hash
      require_login_error_flash "Please log in to continue."
      template_opts layout: nil
      unverified_account_message "Unverified user, please verify before logging in."

      # Feature (automatic): login_password_requirements_base
      require_password_confirmation? false

      # Feature: active_sessions
      active_sessions_account_id_column :user_id
      active_sessions_table :user_active_session_key

      # Feature: audit_logging
      audit_logging_table :user_authentication_audit_log
      audit_logging_account_id_column :user_id

      # Feature: change_login
      change_login_route "me/login"
      change_login_view { view "login_update", nil }

      # Feature: change_password
      change_password_route "me/password"
      change_password_view { view "password_update", nil }
      change_password_button "Save"

      # Feature: create_account
      create_account_button "Create"
      create_account_link_text "Register."
      create_account_route "register"
      create_account_view { view "register", nil }
      change_login_button "Save"

      after_create_account do
        user_id = account[:id]
        user_name = param "name"
        account_id = db[:account].insert label: user_name, name: user_name.snakecase

        db[:user].where(id: user_id).update name: user_name
        db[:membership].insert user_id: user_id, account_id:
      end

      # Feature (custom): hanami
      hanami_view(proc { View.new })

      # Feature: jwt
      jwt_secret Hanami.app[:settings].app_secret
      jwt_refresh_route "api/jwt"

      # Feature: jwt_refresh
      jwt_access_token_not_before_period Hanami.app[:settings].api_access_token_period
      jwt_refresh_token_account_id_column :user_id
      jwt_refresh_token_table :user_jwt_refresh_key

      # Feature: login
      login_error_flash "There was an error signing in."
      login_form_footer_links_heading { nil }
      login_notice_flash "You have been logged in."
      login_return_to_requested_location? true
      multi_phase_login_view { view "login_multi_phase", nil }

      # Feature: logout
      logout_notice_flash "You have been logged out."
      logout_redirect "/"

      # Feature: remember
      remember_button "Save"
      remember_table :user_remember_key
      remember_route "me/remember"

      # Feature: recovery_codes
      recovery_codes_table :user_recovery_code
    end

    route do |request|
      env["rodauth"] = rodauth
      request.rodauth
    end
  end
end
